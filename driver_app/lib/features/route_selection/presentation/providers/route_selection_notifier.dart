import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteItem {
  const RouteItem({required this.id, required this.name});
  final String id;
  final String name;
}

sealed class RouteSelectionState {
  const RouteSelectionState();
}

final class RouteSelectionLoading extends RouteSelectionState {
  const RouteSelectionLoading();
}

final class RouteSelectionLoaded extends RouteSelectionState {
  const RouteSelectionLoaded(this.routes);
  final List<RouteItem> routes;
}

final class RouteSelectionError extends RouteSelectionState {
  const RouteSelectionError(this.message);
  final String message;
}

final routeSelectionProvider =
    NotifierProvider<RouteSelectionNotifier, RouteSelectionState>(
  RouteSelectionNotifier.new,
);

class RouteSelectionNotifier extends Notifier<RouteSelectionState> {
  @override
  RouteSelectionState build() {
    _loadRoutes();
    return const RouteSelectionLoading();
  }

  Future<void> _loadRoutes() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('routes').get();
      final routes = snapshot.docs.map((doc) {
        final data = doc.data();
        return RouteItem(
          id: doc.id,
          name: data['name'] as String? ?? doc.id,
        );
      }).toList();
      state = RouteSelectionLoaded(routes);
    } catch (e) {
      state = RouteSelectionError(e.toString());
    }
  }

  Future<void> reload() async {
    state = const RouteSelectionLoading();
    await _loadRoutes();
  }
}
