import 'package:live_map/live_map.dart';

class MapState {
  final MapDimensionMode dimensionMode;
  final MapModel? selectedVehicle;

  const MapState({
    required this.dimensionMode,
    this.selectedVehicle,
  });

  factory MapState.initial() => const MapState(
        dimensionMode: MapDimensionMode.twoD,
      );

  MapState copyWith({
    MapDimensionMode? dimensionMode,
    MapModel? Function()? selectedVehicle,
  }) {
    return MapState(
      dimensionMode: dimensionMode ?? this.dimensionMode,
      selectedVehicle: selectedVehicle != null
          ? selectedVehicle()
          : this.selectedVehicle,
    );
  }
}
