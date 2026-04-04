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

class _DsBottomSheetPanelState extends State<DsBottomSheetPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;

  double _dragOffset = 0;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset =
          (_dragOffset + details.delta.dy).clamp(0.0, double.infinity);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset > _closeThreshold ||
        velocity > _closeVelocityThreshold) {
      widget.onClose();
    } else {
      _snapStartOffset = _dragOffset;

      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      final animation =
      CurvedAnimation(parent: controller, curve: Curves.easeOut);

      controller.addListener(() {
        setState(() {
          _dragOffset =
              _snapStartOffset * (1 - animation.value);
        });
      });

      controller.forward().whenComplete(controller.dispose);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _entryController,
        builder: (_, child) {
          final entryOffset =
              (1 - Curves.easeOut.transform(_entryController.value)) *
                  screenHeight;

          return Transform.translate(
            offset: Offset(0, entryOffset + _dragOffset),
            child: child,
          );
        },
        child: Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.dsColors.surface,
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
    );
  }
}