import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';

abstract interface class IVehiclesRepository {
  Stream<List<VehicleEntity>> watchVehicles();
}
