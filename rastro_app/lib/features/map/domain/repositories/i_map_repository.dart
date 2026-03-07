import 'package:rastro/features/map/domain/entities/vehicle_position.dart';

abstract class IMapRepository {
  VehiclePosition get initialPosition;
  List<VehiclePosition> get waypoints;
  Stream<VehiclePosition> watchPositions();
  void startTracking();
  void stopTracking();
}
