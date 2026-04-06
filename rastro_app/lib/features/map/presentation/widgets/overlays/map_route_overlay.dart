import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/providers/map_selection_provider.dart';
import 'package:rastro/features/map/presentation/widgets/overlays/map_selection_card.dart';

class MapRouteOverlay extends ConsumerWidget {
  final ValueNotifier<double> sheetHeight;
  final DsBottomSheetPanelController panelController;

  const MapRouteOverlay({
    required this.sheetHeight,
    required this.panelController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mapNotifierProvider.notifier);
    final selectedItem = ref.watch(selectedItemProvider);

    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 20,
          child: DsFloatingButton(
            size: 38,
            icon: LucideIcons.arrow_left,
            iconSize: 20,
            iconColor: DsColors.blue500,
            onPressed: () {
              ref.read(selectedItemProvider.notifier).clear();
              notifier.clearSelection();
              context.go(AppRoutes.routes);
            },
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: sheetHeight,
          builder: (_, height, child) => Positioned(
            bottom: height + 16,
            right: 20,
            child: child!,
          ),
          child: DsFloatingButton(
            size: 42,
            icon: LucideIcons.locate_fixed,
            iconColor: DsColors.blue500,
            onPressed: () {
              ref.read(selectedItemProvider.notifier).select(const MapSelectedLocation());
              notifier.centerOnUser();
            },
          ),
        ),
        if (selectedItem != null)
          Positioned(
            top: 50,
            right: 20,
            child: MapSelectionCard(item: selectedItem),
          ),
      ],
    );
  }
}
