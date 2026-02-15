import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/services/simulation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env.dev");
  LiveMapWidget.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: true,
      home: const HomePage(),
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = LiveMapController();
  late final MovementSimulationService _simulation;
  var _dimensionMode = MapDimensionMode.twoD;

  @override
  void initState() {
    super.initState();
    _simulation = MovementSimulationService(_controller);
    _simulation.start();
  }

  @override
  void dispose() {
    _simulation.stop();
    super.dispose();
  }

  void _toggleDimension() {
    setState(() {
      _dimensionMode = _dimensionMode == MapDimensionMode.twoD
          ? MapDimensionMode.threeD
          : MapDimensionMode.twoD;
    });
    _controller.toggleDimensionMode(_dimensionMode);
  }

  void _showEventDebugSheet() {
    AppBottomSheet.show(
      context: context,
      showCloseButton: true,
      child: _EventDebugList(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveMapWidget(
        config: LiveMapConfig(
          styleMode: MapStyleMode.day,
          dimensionMode: MapDimensionMode.twoD,
          modelConfig: ModelConfig(
            modelPath: 'assets/models/bus.glb',
            scale: [2.5, 2.5, 2.5],
            rotation: [0, 0, 112],
          ),
          initialLatitude: -0.1987990,
          initialLongitude: -78.4982523,
          initialZoom: 19,
          initialModels: [
            MapModel(
              id: 'bus-1',
              latitude: -0.1987990,
              longitude: -78.4982523,
            ),
          ],
          waypoints: MovementSimulationService.waypoints,
        ),
        controller: _controller,
        onModelTap: (model) {
          AppBottomSheet.show(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(model.id, bold: true),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppFloatingButton(
              onPressed: _showEventDebugSheet,
              variant: ButtonVariant.black,
              icon: Icons.bug_report,
            ),
            AppFloatingButton(
              onPressed: _toggleDimension,
              variant: ButtonVariant.black,
              icon: _dimensionMode == MapDimensionMode.twoD
                  ? Icons.threed_rotation_sharp
                  : Icons.layers,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Event debug list (live-updating via StreamBuilder)
// -----------------------------------------------------------------------------

class _EventDebugList extends StatelessWidget {
  final LiveMapController controller;

  const _EventDebugList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LiveMapState>(
      stream: controller.stateStream,
      builder: (context, _) {
        final events = controller.eventHistory;
        if (events.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: AppText('No events yet')),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText('Event Log (${events.length})', bold: true),
            const SizedBox(height: 12),
            for (final event in events)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: AppText(
                  _describeEvent(event),
                ),
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
      TrackingPositionReceived(:final modelId, :final latitude, :final longitude) =>
        'Position: $modelId (${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)})',
      StyleModeChanged(:final styleMode) =>
        'StyleModeChanged: ${styleMode.name}',
      DimensionModeChanged(:final dimensionMode) =>
        'DimensionModeChanged: ${dimensionMode.name}',
    };
  }
}
