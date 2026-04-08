import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:rastro/features/search/presentation/search_controller_provider.dart';
import 'package:rastro/features/search/presentation/search_notifier.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchControllerProvider);
    final user = ref.watch(authSessionProvider).asData?.value;
    final firstName = user?.displayName?.split(' ').first ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsText('Hola, $firstName!', variant: TextVariant.title),
        DsText(
          '¿A dónde vas hoy?',
          variant: TextVariant.regular2,
          color: DsColors.zinc500,
        ),
        SizedBox(height: DsLayout.spacingLg),
        DsSearchBar(
          hintText: 'Buscar bus, parada, ruta...',
          controller: controller,
          onChanged: (query) {
            ref.read(searchProvider.notifier).search(query);
          },
        ),
      ],
    );
  }
}
