import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:live_map/live_map.dart';

class EventDebugList extends StatelessWidget {
  final LiveMapController controller;

  const EventDebugList({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LiveMapState>(
      stream: controller.stateStream,
      builder: (context, _) {
        final events = controller.eventHistory;
        if (events.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: DsText('No events yet')),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DsText('Event Log (${events.length})', bold: true),
            const SizedBox(height: 12),
            for (final event in events)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: DsText(_describeEvent(event)),
              ),
          ],
        );
      },
    );
  }

  static String _describeEvent(LiveMapEvent event) {
    return switch (event) {
      MapCreated() => 'MapCreated',
      MapStyleLoaded() => 'MapStyleLoaded',
      MapDisposed() => 'MapDisposed',
      CameraFlyTo(:final latitude, :final longitude) =>
        'CameraFlyTo: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
      CameraMoveTo(:final latitude, :final longitude) =>
        'CameraMoveTo: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
      CameraMoved(:final latitude, :final longitude) =>
        'CameraMoved: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
      ModelsUpdated(:final models) =>
        'ModelsUpdated: ${models.length} models',
      ModelLayerRequested() => 'ModelLayerRequested',
      ModelLayerAdded() => 'ModelLayerAdded',
      ModelLayerFailed(:final error) => 'ModelLayerFailed: $error',
      MapTapped(:final latitude, :final longitude) =>
        'MapTapped: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
      ModelSelected(:final model) => 'ModelSelected: ${model.id}',
      ModelDeselected() => 'ModelDeselected',
      TrackingStarted() => 'TrackingStarted',
      TrackingStopped() => 'TrackingStopped',
      TrackingPositionReceived(
        :final modelId,
        :final latitude,
        :final longitude,
      ) =>
        'Position: $modelId (${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)})',
      DimensionModeChanged(:final dimensionMode) =>
        'DimensionModeChanged: ${dimensionMode.name}',
      RouteAssigned(:final modelId, :final routePoints) =>
        'RouteAssigned: $modelId (${routePoints.length} pts)',
      RouteUpdateNeeded(:final modelId) => 'RouteUpdateNeeded: $modelId',
    };
  }
}
