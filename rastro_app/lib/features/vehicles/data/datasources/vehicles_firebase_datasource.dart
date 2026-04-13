import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';

class VehiclesFirebaseDatasource {
  const VehiclesFirebaseDatasource();

  Future<List<VehicleEntity>> getVehicles() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('vehicles').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final location = data['location'] as Map<String, dynamic>?;
      return VehicleEntity(
        id: doc.id,
        routeId: data['routeId'] as String? ?? '',
        status: data['status'] as String? ?? 'inactive',
        lat: (location?['lat'] as num?)?.toDouble(),
        lng: (location?['lng'] as num?)?.toDouble(),
      );
    }).toList();
  }
}
