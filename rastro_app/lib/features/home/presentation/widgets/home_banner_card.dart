import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';

class HomeBannerCard extends StatelessWidget {
  const HomeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DsGradientCard(
      colors: [DsColors.blue500, DsColors.blue700],
      end: Alignment.bottomRight,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: DsLayout.spacingXl,
            horizontal: DsLayout.spacingXxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsBadge(
                label: 'En vivo',
                color: DsColors.green500,
                variant: BadgeVariant.soft,
                leadingIcon: Icons.circle,
                iconSize: 8,
              ),
              SizedBox(height: DsLayout.spacingMd),
              DsText('Próximo bus', variant: TextVariant.medium2),
              SizedBox(height: DsLayout.spacingXs),
              DsText('Transplaneta', variant: TextVariant.title),
              SizedBox(height: DsLayout.spacingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DsText('Llega en 3 min', variant: TextVariant.medium2),
                  DsButton(
                    text: 'Ver en mapa',
                    height: 36,
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () => context.go(AppRoutes.map),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
