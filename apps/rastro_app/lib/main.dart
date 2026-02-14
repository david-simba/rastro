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
          initialLatitude: -0.1996,
          initialLongitude: -78.4930,
          initialZoom: 19,
          initialModels: [
            MapModel(
              id: 'bus-1',
              latitude: -0.1996,
              longitude: -78.4930,
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
    );
  }
}
