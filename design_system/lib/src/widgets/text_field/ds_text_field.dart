import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final Color cursorColor;
  final double cursorHeight;
  final double cursorWidth;

  const DsTextField({
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.maxLines = 1,
    this.cursorColor = DsColors.blue500,
    this.cursorHeight = 20,
    this.cursorWidth = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          DsText(label!, variant: TextVariant.medium),
          const SizedBox(height: 10),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          cursorColor: cursorColor,
          cursorHeight: 16,
          cursorWidth: cursorWidth,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: DsTypography.regular.copyWith(color: dsColors.muted),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DsLayout.spacingMd,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: DsLayout.borderRadiusSm,
              borderSide: BorderSide(
                color: hasError ? DsColors.orange500 : dsColors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: DsLayout.borderRadiusSm,
              borderSide: BorderSide(
                color: hasError ? DsColors.orange500 : DsColors.blue500,
                width: 1.5,
              ),
            ),
            errorText: null,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          DsText(errorText!, variant: TextVariant.regular2, color: DsColors.orange500),
        ],
      ],
    );
  }
}
