import 'package:flutter/material.dart';
import 'text_variant.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText._(
    this.text, {
      this.style,
      this.align,
      this.maxLines,
      this.overflow,
    });

  factory AppText(
    String text, {
      TextVariant variant = TextVariant.body,
      bool bold = false,
      Color? color,
      TextAlign? align,
      int? maxLines,
      TextOverflow? overflow,
    }) {

    final baseStyle = variant.style;
    return AppText._(
      text,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
        fontWeight: bold ? FontWeight.w500 : baseStyle.fontWeight,
        color: color ?? baseStyle.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
