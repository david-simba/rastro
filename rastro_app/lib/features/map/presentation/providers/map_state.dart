import 'package:live_map/live_map.dart';

class MapState {
  final MapDimensionMode dimensionMode;
  final MapModel? selectedVehicle;
  final LatLng? userPosition;

  const MapState({
    required this.dimensionMode,
    this.selectedVehicle,
    this.userPosition,
  });

  factory MapState.initial() => const MapState(
        dimensionMode: MapDimensionMode.twoD,
      );

  MapState copyWith({
    MapDimensionMode? dimensionMode,
    MapModel? Function()? selectedVehicle,
    LatLng? Function()? userPosition,
  }) {
    return MapState(
      dimensionMode: dimensionMode ?? this.dimensionMode,
      selectedVehicle: selectedVehicle != null ? selectedVehicle() : this.selectedVehicle,
      userPosition: userPosition != null ? userPosition() : this.userPosition,
    );
  }
}
