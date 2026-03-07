class CameraState {
  final double latitude;
  final double longitude;
  final double zoom;
  final double pitch;

  const CameraState({
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.pitch,
  });

  CameraState copyWith({
    double? latitude,
    double? longitude,
    double? zoom,
    double? pitch,
  }) {
    return CameraState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zoom: zoom ?? this.zoom,
      pitch: pitch ?? this.pitch,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraState &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          zoom == other.zoom &&
          pitch == other.pitch;

  @override
  int get hashCode => Object.hash(latitude, longitude, zoom, pitch);
}
