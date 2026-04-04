import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/routes/data/datasources/routes_firebase_datasource.dart';
import 'package:rastro/features/routes/data/repositories/routes_repository_impl.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/routes/domain/repositories/i_routes_repository.dart';

final routesTabProvider = NotifierProvider<RoutesTabNotifier, int>(
  RoutesTabNotifier.new,
);

class RoutesTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final routesRepositoryProvider = Provider<IRoutesRepository>((ref) {
  return RoutesRepositoryImpl(const RoutesFirebaseDatasource());
});

final routesNotifierProvider =
    AsyncNotifierProvider<RoutesNotifier, List<RouteEntity>>(
  RoutesNotifier.new,
);

class RoutesNotifier extends AsyncNotifier<List<RouteEntity>> {
  @override
  Future<List<RouteEntity>> build() {
    return ref.read(routesRepositoryProvider).getRoutes();
  }
}
