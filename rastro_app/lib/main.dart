import 'package:design_system/design_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/core/config/app_config.dart';
import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();
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
      theme: DsTheme.light.copyWith(
        textTheme: DsTheme.light.textTheme.apply(fontFamily: 'Inter'),
      ),
      darkTheme: DsTheme.dark.copyWith(
        textTheme: DsTheme.dark.textTheme.apply(fontFamily: 'Inter'),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
