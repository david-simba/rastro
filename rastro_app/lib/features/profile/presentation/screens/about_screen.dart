import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrow_left,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: DsText('Acerca de la app', variant: TextVariant.subtitle),
        backgroundColor: dsColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DsLayout.spacingXxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DsColors.blue700, DsColors.blue500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: DsLayout.borderRadiusMd,
                      ),
                      child: const Icon(Icons.route, color: DsColors.white, size: 40),
                    ),
                    SizedBox(height: DsLayout.spacingLg),
                    DsText('Rastro', variant: TextVariant.headline, color: dsColors.onBackground),
                    SizedBox(height: DsLayout.spacingXs),
                    DsText('Versión 1.0.0', variant: TextVariant.regular2, color: dsColors.muted),
                  ],
                ),
              ),
              SizedBox(height: DsLayout.spacingXxl),
              DsDivider(),
              SizedBox(height: DsLayout.spacingXxl),
              DsText('Descripción', variant: TextVariant.medium, color: dsColors.muted),
              SizedBox(height: DsLayout.spacingMd),
              DsText(
                'Rastro es una app de rastreo de rutas y vehículos en tiempo real. '
                'Visualizá la ubicación de colectivos, seguí rutas y encontrá las paradas más cercanas.',
                variant: TextVariant.regular,
                color: dsColors.onBackground,
              ),
              SizedBox(height: DsLayout.spacingXxl),
              DsText('Legal', variant: TextVariant.medium, color: dsColors.muted),
              SizedBox(height: DsLayout.spacingMd),
              DsText(
                '© 2026 Rastro. Todos los derechos reservados.',
                variant: TextVariant.regular2,
                color: dsColors.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
