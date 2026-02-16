import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/core/config/app_config.dart';
import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env.dev');

  final config = AppConfig(
    appEnv: dotenv.env['APP_ENV'] ?? 'development',
    mapboxToken: dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '',
  );

  LiveMapWidget.setAccessToken(config.mapboxToken);

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const RastroApp(),
    ),
  );
}

class RastroApp extends ConsumerWidget {
  const RastroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: !config.isProduction,
      theme: ThemeData(fontFamily: 'Poppins'),
      routerConfig: router,
    );
  }
}
