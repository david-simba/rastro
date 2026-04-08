import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/vehicles/data/datasources/vehicles_firebase_datasource.dart';
import 'package:rastro/features/vehicles/data/repositories/vehicles_repository_impl.dart';
import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rastro/features/vehicles/domain/repositories/i_vehicles_repository.dart';

final vehiclesRepositoryProvider = Provider<IVehiclesRepository>((ref) {
  return VehiclesRepositoryImpl(const VehiclesFirebaseDatasource());
});

final vehiclesNotifierProvider = StreamProvider<List<VehicleEntity>>((ref) {
  return ref.watch(vehiclesRepositoryProvider).watchVehicles();
});
