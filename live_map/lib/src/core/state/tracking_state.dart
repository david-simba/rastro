import 'package:live_map/src/domain/types/map_types.dart';

enum TrackingStatus { inactive, active }

class TrackingState {
  final TrackingStatus status;
  final MapModel? destination;

  const TrackingState({
    this.status = TrackingStatus.inactive,
    this.destination,
  });

  TrackingState copyWith({
    TrackingStatus? status,
    MapModel? Function()? destination,
  }) {
    return TrackingState(
      status: status ?? this.status,
      destination: destination != null ? destination() : this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingState &&
          status == other.status &&
          destination == other.destination;

  @override
  int get hashCode => Object.hash(status, destination);
}
