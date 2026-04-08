import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';
import 'dart:io';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/providers/map_selection_provider.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/map/presentation/widgets/map_view.dart';
import 'package:rastro/features/map/presentation/widgets/overlays/map_default_overlay.dart';
import 'package:rastro/features/map/presentation/widgets/overlays/map_route_overlay.dart';
import 'package:rastro/features/map/presentation/widgets/routes/route_details_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({
    this.vehicleId,
    this.initialLat,
    this.initialLng,
    super.key,
  });

  final String? vehicleId;
  final double? initialLat;
  final double? initialLng;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final ValueNotifier<double> _sheetHeight;
  late final ProviderSubscription<MapState> _mapStateSub;
  late final ProviderSubscription<MapSelectedItem?> _selectionSub;
  final _panelController = DsBottomSheetPanelController();

  @override
  void initState() {
    super.initState();
    _sheetHeight = ValueNotifier(400);
    _mapStateSub = ref.listenManual(mapNotifierProvider, _onMapStateChanged);
    _selectionSub = ref.listenManual(selectedItemProvider, _onSelectionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(mapNotifierProvider).mode == MapMode.routeSelected &&
          ref.read(selectedItemProvider) == null) {
        ref.read(selectedItemProvider.notifier).selectSilent(const MapSelectedRoute());
      }
      _triggerVehicleTrackingIfNeeded();
    });
  }

  void _triggerVehicleTrackingIfNeeded() {
    if (widget.vehicleId == null) return;
    final userPos = ref.read(mapNotifierProvider).userPosition;
    if (userPos != null) {
      Future.delayed(const Duration(milliseconds: 400), _startVehicleTracking);
    }
    // else: _onMapStateChanged handles it when userPosition becomes non-null
  }

  void _startVehicleTracking() {
    if (!mounted) return;
    final model = MapModel(
      id: widget.vehicleId!,
      latitude: widget.initialLat ?? -0.3015,
      longitude: widget.initialLng ?? -78.53507,
    );
    ref.read(mapNotifierProvider.notifier).startTracking(model);
  }

  @override
  void dispose() {
    _sheetHeight.dispose();
    _mapStateSub.close();
    _selectionSub.close();
    super.dispose();
  }

  void _onMapStateChanged(MapState? prev, MapState next) {
    if (prev?.mode != MapMode.routeSelected && next.mode == MapMode.routeSelected) {
      ref.read(selectedItemProvider.notifier).selectSilent(const MapSelectedRoute());
    }
    if (widget.vehicleId != null &&
        prev?.userPosition == null &&
        next.userPosition != null) {
      Future.delayed(const Duration(milliseconds: 400), _startVehicleTracking);
    }
  }

  void _onSelectionChanged(MapSelectedItem? _, MapSelectedItem? next) {
    if (next == null) return;
    if (ref.read(selectedItemProvider.notifier).isSilent) return;
    final notifier = ref.read(mapNotifierProvider.notifier);
    switch (next) {
      case MapSelectedStop(:final stop):
        notifier.flyToStop(stop.latitude, stop.longitude);
        _panelController.snapToMin();
      case MapSelectedRoute():
        notifier.fitSelectedRoute();
        if (_sheetHeight.value >= _panelController.maxHeight) {
          _panelController.snapToNormal();
        }
      case MapSelectedLocation():
        _panelController.snapToMin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapNotifierProvider);
    final isRouteSelected = mapState.mode == MapMode.routeSelected;

    return Stack(
      children: [
        MapView(onModelTap: (model) => _showVehicleInfo(context, model)),
        if (!isRouteSelected) const MapDefaultOverlay(),
        if (isRouteSelected)
          MapRouteOverlay(
            sheetHeight: _sheetHeight,
            panelController: _panelController,
          ),
        if (mapState.selectedRoute != null)
          DsBottomSheetPanel(
            controller: _panelController,
            minHeight: Platform.isIOS ? 112 : 124,
            onHeightChanged: (h) => _sheetHeight.value = h,
            child: RouteDetailsSheet(route: mapState.selectedRoute!),
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
