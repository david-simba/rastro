import 'package:rastro/features/map/data/datasources/simulation_datasource.dart';
import 'package:rastro/features/map/domain/entities/vehicle_position.dart';
import 'package:rastro/features/map/domain/repositories/i_map_repository.dart';

class MapRepositoryImpl implements IMapRepository {
  final SimulationDatasource _datasource;

  MapRepositoryImpl(this._datasource);

  @override
  VehiclePosition get initialPosition => VehiclePosition(
        id: SimulationDatasource.vehicleId,
        latitude: SimulationDatasource.routeWaypoints[0].latitude,
        longitude: SimulationDatasource.routeWaypoints[0].longitude,
      );

  @override
  Stream<VehiclePosition> watchPositions() => _datasource.positionStream;

  @override
  void setRoute(List<VehiclePosition> points) => _datasource.setRoute(points);

  @override
  void startTracking() => _datasource.start();

  @override
  void stopTracking() => _datasource.stop();
}
