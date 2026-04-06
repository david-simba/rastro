import 'package:design_system/design_system.dart';
import 'package:design_system/src/widgets/bottom_sheet/ds_bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class DsBottomSheetPanel extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double normalHeight;
  final double maxHeight;
  final void Function(double height)? onHeightChanged;

  const DsBottomSheetPanel({
    required this.child,
    this.minHeight = 180,
    this.normalHeight = 400,
    this.maxHeight = 700,
    this.onHeightChanged,
    super.key,
  });

  @override
  State<DsBottomSheetPanel> createState() => _DsBottomSheetPanelState();
}

class _DsBottomSheetPanelState extends State<DsBottomSheetPanel>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _snapController;
  late final ValueNotifier<double> _currentHeight;
  OverlayEntry? _overlayEntry;

  double _snapFrom = 0;
  double _snapTo = 0;

  static const double _snapVelocityThreshold = 600;

  @override
  void initState() {
    super.initState();

    _currentHeight = ValueNotifier(widget.normalHeight);

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _snapController.addListener(() {
      final t = Curves.easeOut.transform(_snapController.value);
      _currentHeight.value = _snapFrom + (_snapTo - _snapFrom) * t;
    });

    _currentHeight.addListener(() {
      widget.onHeightChanged?.call(_currentHeight.value);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _overlayEntry = OverlayEntry(builder: _buildPanel);
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _entryController.dispose();
    _snapController.dispose();
    _currentHeight.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_snapController.isAnimating) _snapController.stop();
    // Drag up (negative dy) increases height, drag down decreases it
    _currentHeight.value = (_currentHeight.value - details.delta.dy)
        .clamp(widget.minHeight, widget.maxHeight);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final snapPoints = [widget.minHeight, widget.normalHeight, widget.maxHeight];
    final current = _currentHeight.value;

    // Find nearest snap point index
    int nearestIndex = 0;
    double minDiff = double.infinity;
    for (int i = 0; i < snapPoints.length; i++) {
      final diff = (current - snapPoints[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }

    final double target;
    if (velocity < -_snapVelocityThreshold) {
      // Fast upward → advance one level up
      target = snapPoints[(nearestIndex + 1).clamp(0, snapPoints.length - 1)];
    } else if (velocity > _snapVelocityThreshold) {
      // Fast downward → go one level down
      target = snapPoints[(nearestIndex - 1).clamp(0, snapPoints.length - 1)];
    } else {
      // Slow drag → snap to nearest
      target = snapPoints[nearestIndex];
    }

    _snapFrom = _currentHeight.value;
    _snapTo = target;
    _snapController.forward(from: 0);
  }

  Widget _buildPanel(BuildContext overlayContext) {
    final screenHeight = MediaQuery.of(overlayContext).size.height;
    final textDirection = Directionality.of(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Directionality(
        textDirection: textDirection,
        child: Material(
          type: MaterialType.transparency,
          child: ValueListenableBuilder<double>(
            valueListenable: _currentHeight,
            builder: (_, height, child) {
              return AnimatedBuilder(
                animation: _entryController,
                builder: (_, _) {
                  final entryOffset =
                      (1 - Curves.easeOut.transform(_entryController.value)) *
                          screenHeight;
                  return Transform.translate(
                    offset: Offset(0, entryOffset),
                    child: Container(
                      height: height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: overlayContext.dsColors.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(DsLayout.radiusMd),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _onDragUpdate,
                  onVerticalDragEnd: _onDragEnd,
                  child: const DsBottomSheetHeader(showCloseButton: false),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      DsLayout.spacingLg,
                      0,
                      DsLayout.spacingLg,
                      DsLayout.spacingLg,
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
