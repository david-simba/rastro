import 'package:rastro/features/map/domain/entities/vehicle_position.dart';

abstract class IMapRepository {
  VehiclePosition get initialPosition;
  Stream<VehiclePosition> watchPositions();
  void setRoute(List<VehiclePosition> points);
  void startTracking();
  void stopTracking();
}
