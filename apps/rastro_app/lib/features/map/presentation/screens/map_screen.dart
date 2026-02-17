import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/widgets/map_controls.dart';
import 'package:rastro/features/map/presentation/widgets/map_view.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapNotifierProvider.notifier).startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final mapState = ref.watch(mapNotifierProvider);

    return Stack(
      children: [
        MapView(onModelTap: _showVehicleInfo),
        Positioned(
          top: 110,
          right: 10,
          child: MapControls(
            showDebug: config.isDevelopment,
            dimensionMode: mapState.dimensionMode,
          ),
        ),
      ],
    );
  }

  void _showVehicleInfo(MapModel model) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(model.id, bold: true),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
