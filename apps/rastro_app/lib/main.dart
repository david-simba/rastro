import 'package:app_ui/app_ui.dart';
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
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onModelTap: (model) {
          AppBottomSheet.show(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(model.id, bold: true,),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
