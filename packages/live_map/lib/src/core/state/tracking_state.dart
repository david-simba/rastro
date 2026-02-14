enum TrackingStatus { inactive, active }

class TrackingState {
  final TrackingStatus status;

  const TrackingState({this.status = TrackingStatus.inactive});

  TrackingState copyWith({TrackingStatus? status}) {
    return TrackingState(status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingState && status == other.status;

  @override
  int get hashCode => status.hashCode;
}
