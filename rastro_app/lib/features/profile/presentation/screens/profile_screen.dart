import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/auth/presentation/providers/auth_notifier.dart';
import 'package:rastro/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:rastro/features/profile/presentation/widgets/profile_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionProvider).asData?.value;

    return Scaffold(
      body: Column(
        children: [
          ProfileHeader(
            name: user?.displayName ?? 'User',
            email: user?.email ?? 'User@email.com',
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
                    onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
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
