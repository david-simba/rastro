import 'dart:convert';

import 'package:live_map/src/domain/types/map_types.dart';
import 'package:live_map/src/infrastructure/utils/model_interpolator.dart';

class ModelGeoJsonBuilder {
  const ModelGeoJsonBuilder._();

  /// Builds a static FeatureCollection from the given [models].
  static String fromModels(List<MapModel> models) {
    return jsonEncode(_featureCollection(
      models.map((m) => _feature(m.id, m.longitude, m.latitude, m.bearing)),
    ));
  }

  /// Builds a FeatureCollection using interpolated positions where available,
  /// falling back to the model's stored position otherwise.
  static String fromInterpolated(
    List<MapModel> models,
    Map<String, ModelInterpolator> lerps,
  ) {
    return jsonEncode(_featureCollection(
      models.map((m) {
        final lerp = lerps[m.id];
        return _feature(
          m.id,
          lerp?.lng ?? m.longitude,
          lerp?.lat ?? m.latitude,
          lerp?.bearing ?? m.bearing,
        );
      }),
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
