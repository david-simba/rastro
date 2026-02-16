class VehiclePosition {
  final String id;
  final double latitude;
  final double longitude;
  final double bearing;

  const VehiclePosition({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.bearing = 0.0,
  });
}
