import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/features/routes/presentation/providers/routes_notifier.dart';

class RoutesTabSelector extends ConsumerWidget {
  const RoutesTabSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(routesTabProvider);

    return DsTabSelector(
      tabs: const ['Todas', 'Favoritas'],
      selectedIndex: selectedIndex,
      onTabSelected: (index) =>
          ref.read(routesTabProvider.notifier).select(index),
    );
  }
}
