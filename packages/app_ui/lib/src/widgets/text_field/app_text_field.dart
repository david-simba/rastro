import 'package:flutter/material.dart';
import 'package:app_ui/src/theme/typography.dart';
import 'package:app_ui/src/widgets/text/app_text.dart';
import 'package:app_ui/src/widgets/text/text_variant.dart';
import 'package:app_ui/src/theme/colors.dart';

class AppTextField extends StatelessWidget {
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

  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.maxLines = 1,
    this.cursorColor = AppColors.primary,
    this.cursorHeight = 20,
    this.cursorWidth = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppText(label!, bold: true, variant: TextVariant.body),
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
            hintStyle: AppTypography.body.copyWith(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.danger : AppColors.slate,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? AppColors.danger : AppColors.primary,
                width: 1.5,
              ),
            ),
            errorText: null,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          AppText(
            errorText!,
            variant: TextVariant.label,
            color: AppColors.danger,
          ),
        ],
      ],
    );
  }
}
