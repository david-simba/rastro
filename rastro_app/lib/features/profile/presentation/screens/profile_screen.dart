import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/providers/theme_provider.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/auth/presentation/providers/auth_notifier.dart';
import 'package:rastro/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:rastro/features/profile/presentation/widgets/profile_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionProvider).asData?.value;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final accent = isDark ? DsColors.zinc700 : DsColors.zinc200;

    return Scaffold(
      body: Column(
        children: [
          ProfileHeader(
            name: user?.displayName ?? 'Usuario',
            email: user?.email ?? '',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DsLayout.spacingXxl),
                  _SectionLabel('Preferencias'),
                  SizedBox(height: DsLayout.spacingMd),
                  DsSettingsRow(
                    items: [
                      DsSettingsRowItem(
                        title: 'Tema oscuro',
                        accentColor: accent,
                        trailing: DsToggle(
                          value: isDark,
                          onIcon: Icons.dark_mode,
                          offIcon: Icons.light_mode,
                          onChanged: (on) => ref
                              .read(themeModeProvider.notifier)
                              .setMode(on ? ThemeMode.dark : ThemeMode.light),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DsLayout.spacingXxl),
                  _SectionLabel('Información y Soporte'),
                  SizedBox(height: DsLayout.spacingMd),
                  DsSettingsRow(
                    items: [
                      DsSettingsRowItem(
                        title: 'Envía tus comentarios',
                        description: 'Ayudanos a mejorar la app',
                        accentColor: accent,
                        trailingIcon: Icons.arrow_forward_ios,
                        onPress: () => context.go(AppRoutes.feedback),
                      ),
                      DsSettingsRowItem(
                        title: 'Acerca de la app',
                        description: 'Versión, licencias y más',
                        accentColor: accent,
                        trailingIcon: Icons.arrow_forward_ios,
                        onPress: () => context.go(AppRoutes.about),
                      ),
                    ],
                  ),
                  SizedBox(height: DsLayout.spacingXxl),
                  _SectionLabel('Cuenta'),
                  SizedBox(height: DsLayout.spacingMd),
                  DsSettingsRow(
                    items: [
                      DsSettingsRowItem(
                        title: 'Cerrar sesión',
                        accentColor: accent,
                        trailingIcon: Icons.logout,
                        onPress: () => ref.read(authNotifierProvider.notifier).signOut(),
                      ),
                      DsSettingsRowItem(
                        title: 'Eliminar cuenta',
                        accentColor: DsColors.red500,
                        trailingIcon: Icons.delete_outline,
                        trailingColor: DsColors.red500,
                        onPress: () => _confirmDeleteAccount(context, ref),
                      ),
                    ],
                  ),
                  SizedBox(height: DsLayout.spacingXxl + 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar', style: TextStyle(color: DsColors.red500)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return DsText(text, variant: TextVariant.medium, color: context.dsColors.muted);
  }
}
