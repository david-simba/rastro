class RouteEntity {
  final String id;
  final String name;
  final String coopId;
  final String origin;
  final String destination;
  final String geometry;
  final List<String> stops;

  const RouteEntity({
    required this.id,
    required this.name,
    required this.coopId,
    required this.origin,
    required this.destination,
    required this.geometry,
    this.stops = const [],
  });
}
