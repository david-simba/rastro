import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

class StopsFirebaseDatasource {
  const StopsFirebaseDatasource();

  Future<List<StopEntity>> getStopsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('stops')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final geoPoint = data['location'] as GeoPoint;
      return StopEntity(
        id: doc.id,
        name: data['name'] as String,
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      );
    }).toList();
  }
}
