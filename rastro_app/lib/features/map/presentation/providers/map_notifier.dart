import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/data/services/user_location_service.dart';
import 'package:rastro/features/map/presentation/providers/map_controls_notifier.dart';
import 'package:rastro/features/map/presentation/providers/map_route_notifier.dart';
import 'package:rastro/features/map/presentation/providers/map_state.dart';
import 'package:rastro/features/map/presentation/providers/map_tracking_notifier.dart';
import 'package:rastro/features/stops/data/datasources/stops_firebase_datasource.dart';

const _kFallbackLat = -0.2295;
const _kFallbackLng = -78.5243;

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);

class MapNotifier extends Notifier<MapState>
    with MapControlsMixin, MapRouteMixin, MapTrackingMixin {
  late final LiveMapController _controller;
  late final _locationService = UserLocationService();

  @override
  LiveMapController get controller => _controller;

  @override
  UserLocationService get locationService => _locationService;

  @override
  StopsFirebaseDatasource get stopsDatasource => const StopsFirebaseDatasource();

  @override
  MapState build() {
    _controller = LiveMapController();
    _initUserLocation();
    return MapState.initial();
  }

  LiveMapConfig get mapConfig => LiveMapConfig(
    initialLatitude: state.userPosition?.lat ?? _kFallbackLat,
    initialLongitude: state.userPosition?.lng ?? _kFallbackLng,
    dimensionMode: MapDimensionMode.twoD,
    showUserLocation: true,
  );

  Future<void> _initUserLocation() async {
    final position = await locationService.getCurrentPosition();
    state = state.copyWith(
      userPosition: () => position != null
          ? LatLng(lat: position.latitude, lng: position.longitude)
          : const LatLng(lat: _kFallbackLat, lng: _kFallbackLng),
    );
  }
}
