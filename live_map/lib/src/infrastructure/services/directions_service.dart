import 'dart:convert';
import 'dart:io';

import 'package:live_map/src/domain/types/map_types.dart';

/// Thin wrapper around the Mapbox Directions v5 HTTP API.
///
/// Returns the full road-snapped route geometry as an ordered [LatLng] list.
/// The consuming app is responsible for providing a valid [accessToken].
class DirectionsService {
  static const _base =
      'https://api.mapbox.com/directions/v5/mapbox/driving';

  /// Fetches a driving route that passes through all [waypoints] in order.
  ///
  /// Throws an [Exception] on HTTP errors or if the API returns no routes.
  /// Requires at least 2 waypoints.
  static Future<List<LatLng>> fetchRoute({
    required List<LatLng> waypoints,
    required String accessToken,
  }) async {
    assert(waypoints.length >= 2, 'At least 2 waypoints required');

    final coords = waypoints.map((w) => '${w.lng},${w.lat}').join(';');
    final uri = Uri.parse(
      '$_base/$coords'
      '?access_token=$accessToken'
      '&geometries=geojson'
      '&overview=full',
    );

    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        final body = await response.transform(utf8.decoder).join();
        throw Exception('Directions API ${response.statusCode}: $body');
      }

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final routes = json['routes'] as List<dynamic>;
      if (routes.isEmpty) throw Exception('Directions API returned no routes');

      final coordinates =
          routes[0]['geometry']['coordinates'] as List<dynamic>;

      return coordinates
          .map(
            (c) => LatLng(
              lat: (c[1] as num).toDouble(),
              lng: (c[0] as num).toDouble(),
            ),
          )
          .toList();
    } finally {
      client.close();
    }
  }
}
