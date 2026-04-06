import 'package:rastro/features/routes/domain/entities/route_entity.dart';

abstract interface class IRoutesRepository {
  Future<List<RouteEntity>> getRoutes();
}
