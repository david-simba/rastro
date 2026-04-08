class VehicleEntity {
  final String id;
  final String routeId;
  final String status;

  const VehicleEntity({
    required this.id,
    required this.routeId,
    required this.status,
  });

  bool get isActive => status == 'active';
}
