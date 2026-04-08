import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

sealed class TrackingState {
  const TrackingState();
}

final class TrackingIdle extends TrackingState {
  const TrackingIdle();
}

final class TrackingActive extends TrackingState {
  const TrackingActive({
    required this.vehicleId,
    required this.routeId,
    required this.position,
  });
  final String vehicleId;
  final String routeId;
  final Position position;
}

final class TrackingError extends TrackingState {
  const TrackingError(this.message);
  final String message;
}

final trackingProvider =
    NotifierProvider<TrackingNotifier, TrackingState>(TrackingNotifier.new);

class TrackingNotifier extends Notifier<TrackingState> {
  StreamSubscription<Position>? _positionSub;

  @override
  TrackingState build() => const TrackingIdle();

  Future<void> startTracking({
    required String vehicleId,
    required String routeId,
  }) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        state = const TrackingError('Permiso de ubicación denegado');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      state = const TrackingError(
        'Permiso de ubicación denegado permanentemente. Actívalo en Ajustes.',
      );
      return;
    }

    await _positionSub?.cancel();

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (position) async {
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(vehicleId)
            .update({
          'location': {
            'lat': position.latitude,
            'lng': position.longitude,
          },
          'status': 'active',
          'routeId': routeId,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        state = TrackingActive(
          vehicleId: vehicleId,
          routeId: routeId,
          position: position,
        );
      },
      onError: (e) {
        state = TrackingError(e.toString());
      },
    );
  }

  Future<void> stopTracking() async {
    final current = state;
    if (current is! TrackingActive) return;

    await _positionSub?.cancel();
    _positionSub = null;

    await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(current.vehicleId)
        .update({
      'status': 'inactive',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    state = const TrackingIdle();
  }
}
