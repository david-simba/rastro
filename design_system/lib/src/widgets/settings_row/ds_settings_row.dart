import 'package:flutter/material.dart';
import '../../theme/ds_color_tokens.dart';
import '../../theme/ds_layout.dart';
import '../../theme/ds_theme_ext.dart';
import '../divider/ds_divider.dart';
import '../text/ds_text.dart';
import '../text/text_variant.dart';

class DsSettingsRowItem {
  final String title;
  final String? description;
  final IconData? trailingIcon;
  final Color? trailingColor;
  final Color? accentColor;
  final Widget? trailing;
  final VoidCallback? onPress;

  const DsSettingsRowItem({
    required this.title,
    this.description,
    this.trailingIcon,
    this.trailingColor,
    this.accentColor,
    this.trailing,
    this.onPress,
  });
}

class DsSettingsRow extends StatelessWidget {
  final List<DsSettingsRowItem> items;

  const DsSettingsRow({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

    return Container(
      decoration: BoxDecoration(
        color: dsColors.surface,
        borderRadius: DsLayout.borderRadiusSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const DsDivider(),
            _SettingsRowItem(item: items[i], dsColors: dsColors),
          ],
        ],
      ),
    );
  }
}

class _SettingsRowItem extends StatelessWidget {
  final DsSettingsRowItem item;
  final DsThemeColors dsColors;

  const _SettingsRowItem({required this.item, required this.dsColors});

  @override
  Widget build(BuildContext context) {
    final trailing = item.trailing ?? _iconTrailing();

    return GestureDetector(
      onTap: item.onPress,
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (item.accentColor != null)
              Container(width: 4, color: item.accentColor),
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
                          DsText(item.title, variant: TextVariant.regular, color: dsColors.onSurface),
                          if (item.description != null) ...[
                            const SizedBox(height: DsLayout.spacingXs),
                            DsText(item.description!, variant: TextVariant.regular2, color: dsColors.muted),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: DsLayout.spacingMd),
                      trailing,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _iconTrailing() {
    if (item.trailingIcon == null) return null;
    return Icon(item.trailingIcon, size: 16, color: item.trailingColor ?? dsColors.muted);
  }
}
