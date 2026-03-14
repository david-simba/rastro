import 'package:flutter/material.dart';
import '../../theme/ds_theme_ext.dart';

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
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        width: 70,
        height: 4,
        decoration: BoxDecoration(
          color: context.dsColors.border,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      right: 8,
      top: 4,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.close, size: 20, color: context.dsColors.muted),
        splashRadius: 20,
      ),
    );
  }
}
