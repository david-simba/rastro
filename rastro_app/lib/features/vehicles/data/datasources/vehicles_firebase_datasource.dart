import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastro/features/vehicles/domain/entities/vehicle_entity.dart';

class VehiclesFirebaseDatasource {
  const VehiclesFirebaseDatasource();

  Stream<List<VehicleEntity>> watchVehicles() {
    return FirebaseFirestore.instance
        .collection('vehicles')
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  static VehicleEntity _fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final location = data['location'] as Map<String, dynamic>?;
    return VehicleEntity(
      id: doc.id,
      routeId: data['routeId'] as String? ?? '',
      status: data['status'] as String? ?? 'inactive',
      lat: (location?['lat'] as num?)?.toDouble(),
      lng: (location?['lng'] as num?)?.toDouble(),
    );
  }
}
