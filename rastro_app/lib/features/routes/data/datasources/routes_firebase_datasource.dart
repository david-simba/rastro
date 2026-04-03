import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';

class RoutesFirebaseDatasource {
  const RoutesFirebaseDatasource();

  Future<List<RouteEntity>> getRoutes() async {
    final snapshot = await FirebaseFirestore.instance.collection('routes').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RouteEntity(
        id: doc.id,
        name: data['name'] as String,
        coopId: data['coopId'] as String,
        origin: data['origin'] as String,
        destination: data['destination'] as String,
        geometry: (data['geometry'] as String).replaceAll('\\\\', '\\'),
      );
    }).toList();
  }
}
