import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:rastro/features/routes/presentation/widgets/routes_list.dart';
import 'package:rastro/features/routes/presentation/widgets/routes_tab_selector.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DsLayout.spacingLg),
                  DsText('Rutas', variant: TextVariant.title),
                  SizedBox(height: DsLayout.spacingLg),
                  const RoutesTabSelector(),
                  SizedBox(height: DsLayout.spacingLg),
                ],
              ),
            ),
            const Expanded(child: RoutesList()),
          ],
        ),
      ),
    );
  }
}
