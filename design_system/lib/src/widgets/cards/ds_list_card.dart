import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? accentColor;
  final String? badge;
  final VoidCallback? onPress;

  const DsListCard({
    required this.title,
    this.subtitle,
    this.trailing,
    this.accentColor,
    this.badge,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

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
                Container(
                  width: 6,
                  color: accentColor,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DsLayout.spacingLg,
                    vertical: DsLayout.spacingMd
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (badge != null) ...[
                                  DsBadge(label: badge!, variant: BadgeVariant.solid, rounded: false, color: accentColor ?? DsColors.blue500,),
                                  const SizedBox(width: DsLayout.spacingSm),
                                ],
                                DsText(title, variant: TextVariant.medium, color: dsColors.onSurface),
                              ],
                            ),
                            if (subtitle != null)...[
                              const SizedBox(height: DsLayout.spacingXs),
                              DsText(subtitle!, variant: TextVariant.regular2, color: dsColors.muted),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) ...[
                        const SizedBox(width: DsLayout.spacingMd),
                        trailing!,
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
}
