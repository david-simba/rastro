import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/map/presentation/widgets/map_view.dart';
import 'package:rastro/features/map/presentation/widgets/overlays/map_default_overlay.dart';
import 'package:rastro/features/map/presentation/widgets/overlays/map_route_overlay.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_details_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final ValueNotifier<double> _sheetHeight;
  final _panelController = DsBottomSheetPanelController();

  @override
  void initState() {
    super.initState();
    _sheetHeight = ValueNotifier(400);
  }

  @override
  void dispose() {
    _sheetHeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapNotifierProvider);
    final isRouteSelected = mapState.mode == MapMode.routeSelected;

    return Stack(
      children: [
        MapView(onModelTap: (model) => _showVehicleInfo(context, model)),
        if (!isRouteSelected) const MapDefaultOverlay(),
        if (isRouteSelected) MapRouteOverlay(sheetHeight: _sheetHeight),
        if (mapState.selectedRoute != null)
          DsBottomSheetPanel(
            controller: _panelController,
            onHeightChanged: (h) => _sheetHeight.value = h,
            child: RouteDetailsSheet(
              route: mapState.selectedRoute!,
              onStopTap: _panelController.snapToMin,
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
