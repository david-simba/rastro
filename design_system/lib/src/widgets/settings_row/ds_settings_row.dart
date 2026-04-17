import 'package:flutter/material.dart';
import '../../theme/ds_color_tokens.dart';
import '../../theme/ds_colors.dart';
import '../../theme/ds_layout.dart';
import '../../theme/ds_theme_ext.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsSettingsRow extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? trailingIcon;
  final Color? trailingColor;
  final Color? accentColor;
  final Widget? trailing;
  final VoidCallback? onPress;

  const DsSettingsRow({
    required this.title,
    this.description,
    this.trailingIcon,
    this.trailingColor,
    this.accentColor,
    this.trailing,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;
    final effectiveTrailing = trailing ?? _buildIconTrailing(dsColors);

    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: dsColors.surface,
          borderRadius: DsLayout.borderRadiusSm,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (accentColor != null)
                Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DsLayout.spacingLg,
                    vertical: DsLayout.spacingMd,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DsText(title, variant: TextVariant.regular, color: dsColors.onSurface),
                            if (description != null) ...[
                              const SizedBox(height: DsLayout.spacingXs),
                              DsText(description!, variant: TextVariant.regular2, color: dsColors.muted),
                            ],
                          ],
                        ),
                      ),
                      if (effectiveTrailing != null) ...[
                        const SizedBox(width: DsLayout.spacingMd),
                        effectiveTrailing,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildIconTrailing(DsThemeColors dsColors) {
    if (trailingIcon == null) return null;
    return Icon(
      trailingIcon,
      size: 16,
      color: trailingColor ?? dsColors.muted,
    );
  }
}
