import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/profile/presentation/widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ProfileHeader(
            name: 'David Simba',
            email: 'david@rastro.app',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: DsLayout.spacingXxl),
                  DsButton(
                    text: 'Cerrar sesión',
                    fullWidth: true,
                    color: DsColors.red500,
                    onPressed: () => context.go(AppRoutes.auth),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
