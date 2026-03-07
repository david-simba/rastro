import 'package:live_map/src/domain/types/map_types.dart';

class SelectModelOnTap {
  const SelectModelOnTap();

  MapModel? execute(
    List<MapModel> models, {
    required double latitude,
    required double longitude,
    double threshold = MapModel.defaultThreshold,
  }) {
    for (final model in models) {
      if (model.isNear(latitude, longitude, threshold: threshold)) {
        return model;
      }
    }
    return null;
  }
}
