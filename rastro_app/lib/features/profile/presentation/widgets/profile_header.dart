import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({
    required this.name,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return DsGradientCard(
      colors: [DsColors.blue700, DsColors.blue500],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      rounded: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          DsLayout.spacingXxl,
          paddingTop + DsLayout.spacingXxl,
          DsLayout.spacingXxl,
          DsLayout.spacingLg,
        ),
        child: Row(
          children: [
            DsAvatar(name: name, size: 48),
            SizedBox(width: DsLayout.spacingLg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DsText(name, variant: TextVariant.title),
                SizedBox(height: DsLayout.spacingXs),
                DsText(email, variant: TextVariant.regular2, color: DsColors.blue200),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
