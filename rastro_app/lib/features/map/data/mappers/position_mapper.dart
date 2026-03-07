import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/domain/entities/vehicle_position.dart';

class PositionMapper {
  PositionMapper._();

  static MapModel toMapModel(VehiclePosition position) {
    return MapModel(
      id: position.id,
      latitude: position.latitude,
      longitude: position.longitude,
      bearing: position.bearing,
    );
  }

  static VehiclePosition fromMapModel(MapModel model) {
    return VehiclePosition(
      id: model.id,
      latitude: model.latitude,
      longitude: model.longitude,
      bearing: model.bearing,
    );
  }
}
