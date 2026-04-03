import 'package:rastro/features/routes/data/datasources/routes_firebase_datasource.dart';
import 'package:rastro/features/routes/domain/entities/route_entity.dart';
import 'package:rastro/features/routes/domain/repositories/i_routes_repository.dart';

class RoutesRepositoryImpl implements IRoutesRepository {
  const RoutesRepositoryImpl(this._datasource);

  final RoutesFirebaseDatasource _datasource;

  @override
  Future<List<RouteEntity>> getRoutes() => _datasource.getRoutes();
}
