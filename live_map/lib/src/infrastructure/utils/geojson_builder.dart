import 'dart:convert';

import 'package:live_map/src/domain/types/map_types.dart';

class ModelGeoJsonBuilder {
  const ModelGeoJsonBuilder._();

  /// Builds a static FeatureCollection from the given [models].
  static String fromModels(List<MapModel> models) {
    return jsonEncode(_featureCollection(
      models.map((m) => _feature(m.id, m.longitude, m.latitude, m.bearing)),
    ));
  }

  static Map<String, Object> _featureCollection(
    Iterable<Map<String, Object>> features,
  ) {
    return {
      'type': 'FeatureCollection',
      'features': features.toList(),
    };
  }

  static Map<String, Object> _feature(
    String id,
    double lng,
    double lat,
    double bearing,
  ) {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': [lng, lat],
      },
      'properties': {'modelId': id, 'modelBearing': bearing},
    };
  }
}
