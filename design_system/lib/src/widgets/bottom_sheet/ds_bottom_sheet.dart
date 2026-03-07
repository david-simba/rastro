import 'package:flutter/material.dart';
import 'ds_bottom_sheet_header.dart';

class DsBottomSheet extends StatelessWidget {
  const DsBottomSheet({
    super.key,
    required this.child,
    this.showCloseButton = false,
  });

  final Widget child;
  final bool showCloseButton;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool showCloseButton = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.6,
        child: DsBottomSheet(
          showCloseButton: showCloseButton,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsBottomSheetHeader(showCloseButton: showCloseButton),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
