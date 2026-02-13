import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_map/live_map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env.dev");
  LiveMapWidget.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: LiveMapWidget(
          config: LiveMapConfig(
            styleMode: MapStyleMode.day,
            dimensionMode: MapDimensionMode.threeD,
            modelConfig: ModelConfig(
              modelPath: 'assets/models/bus.glb',
              scale: [2.5, 2.5, 2.5],
              rotation: [0, 0, 112],
            ),
            dataSource: MockLiveMapDataSource(),
          ),
        ),
      ),
    ),
  );
}
