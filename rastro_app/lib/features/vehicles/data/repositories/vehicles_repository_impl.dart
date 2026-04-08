import 'package:rastro/features/vehicles/data/datasources/vehicles_firebase_datasource.dart';
import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rastro/features/vehicles/domain/repositories/i_vehicles_repository.dart';

class VehiclesRepositoryImpl implements IVehiclesRepository {
  const VehiclesRepositoryImpl(this._datasource);

  final VehiclesFirebaseDatasource _datasource;

  @override
  Stream<List<VehicleEntity>> watchVehicles() => _datasource.watchVehicles();
}
