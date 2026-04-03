import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/widgets/map_controls.dart';
import 'package:rastro/features/map/presentation/widgets/map_view.dart';
import 'package:rastro/features/search/presentation/search_controller_provider.dart';
import 'package:rastro/features/search/presentation/search_notifier.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final mapState = ref.watch(mapNotifierProvider);
    final controller = ref.watch(searchControllerProvider);

    return Stack(
      children: [
        MapView(onModelTap: (model) => _showVehicleInfo(context, model)),
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: DsSearchBar(
            hintText: "Buscar bus, parada, ruta...",
            controller: controller,
            onChanged: (query) {
              ref.read(searchProvider.notifier).search(query);
            },
          ),
        ),
        Positioned(
          top: 120,
          right: 20,
          child: MapControls(
            showDebug: config.isDevelopment,
            dimensionMode: mapState.dimensionMode,
          ),
        ),
      ],
    );
  }

  void _showVehicleInfo(BuildContext context, MapModel model) {
    DsBottomSheet.show(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsText(model.id, variant: TextVariant.medium),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
