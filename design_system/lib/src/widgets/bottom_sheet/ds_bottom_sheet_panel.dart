import 'package:design_system/design_system.dart';
import 'package:design_system/src/widgets/bottom_sheet/ds_bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class DsBottomSheetPanel extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final double height;

  const DsBottomSheetPanel({
    required this.child,
    required this.onClose,
    this.height = 400,
    super.key,
  });

  @override
  State<DsBottomSheetPanel> createState() => _DsBottomSheetPanelState();
}

class _DsBottomSheetPanelState extends State<DsBottomSheetPanel> with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _snapController;
  OverlayEntry? _overlayEntry;

  final ValueNotifier<double> _dragOffset = ValueNotifier<double>(0);
  double _snapStartOffset = 0;

  static const double _closeThreshold = 80;
  static const double _closeVelocityThreshold = 600;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _snapController.addListener(() {
      _dragOffset.value = _snapStartOffset *
          (1 - Curves.easeOut.transform(_snapController.value));
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
    _dragOffset.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_snapController.isAnimating) {
      _snapController.stop();
    }
    _dragOffset.value =
        (_dragOffset.value + details.delta.dy).clamp(0.0, double.infinity);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset.value > _closeThreshold ||
        velocity > _closeVelocityThreshold) {
      widget.onClose();
    } else {
      _snapStartOffset = _dragOffset.value;
      _snapController.forward(from: 0);
    }
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
          child: AnimatedBuilder(
            animation: _entryController,
            builder: (_, child) {
              final entryOffset =
                  (1 - Curves.easeOut.transform(_entryController.value)) *
                      screenHeight;

              return ValueListenableBuilder<double>(
                valueListenable: _dragOffset,
                builder: (_, dragValue, __) {
                  return Transform.translate(
                    offset: Offset(0, entryOffset + dragValue),
                    child: child,
                  );
                },
              );
            },
            child: Container(
              height: widget.height,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragUpdate: _onDragUpdate,
                    onVerticalDragEnd: _onDragEnd,
                    child: DsBottomSheetHeader(
                      showCloseButton: true,
                      onClose: widget.onClose,
                    ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}