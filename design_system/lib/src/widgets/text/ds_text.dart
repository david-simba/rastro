import 'package:flutter/material.dart';
import 'text_variant.dart';

class DsText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const DsText._(
    this.text, {
      this.style,
      this.align,
      this.maxLines,
      this.overflow,
    });

  factory DsText(
    String text, {
      TextVariant variant = TextVariant.regular,
      Color? color,
      TextAlign? align,
      int? maxLines,
      TextOverflow? overflow,
    }) {

    final baseStyle = variant.style;
    return DsText._(
      text,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
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
