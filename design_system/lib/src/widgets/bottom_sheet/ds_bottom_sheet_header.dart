import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsBottomSheetHeader extends StatelessWidget {
  const DsBottomSheetHeader({
    super.key,
    required this.showCloseButton,
  });

  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildDragHandle(context),
          if (showCloseButton) _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsLayout.spacingXl),
      child: Container(
        width: 70,
        height: DsLayout.bottomSheetHandle,
        decoration: BoxDecoration(
          color: context.dsColors.border,
          borderRadius: DsLayout.borderRadiusMd,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      right: DsLayout.spacingSm,
      top: DsLayout.spacingXs,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.close, size: 20, color: context.dsColors.muted),
        splashRadius: 20,
      ),
    );
  }
}
