import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';

abstract interface class IVehiclesRepository {
  Future<List<VehicleEntity>> getVehicles();
}
