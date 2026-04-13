class VehicleEntity {
  final String id;
  final String routeId;
  final String status;
  final double? lat;
  final double? lng;

  const VehicleEntity({
    required this.id,
    required this.routeId,
    required this.status,
    this.lat,
    this.lng,
  });

  bool get isActive => status == 'active';
  bool get hasLocation => lat != null && lng != null;
}
