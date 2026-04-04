import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/stops/data/datasources/stops_firebase_datasource.dart';
import 'package:rastro/features/stops/domain/entities/stop_entity.dart';

const _datasource = StopsFirebaseDatasource();

final stopsForIdsProvider = FutureProvider.autoDispose
    .family<List<StopEntity>, List<String>>((ref, ids) {
  return _datasource.getStopsByIds(ids);
});
