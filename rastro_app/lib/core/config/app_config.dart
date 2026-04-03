class AppConfig {
  final String appEnv;
  final String mapboxToken;

  const AppConfig({
    required this.appEnv,
    required this.mapboxToken,
  });

  bool get isProduction => appEnv.trim().toLowerCase() == 'production';
  bool get isDevelopment => appEnv.trim().toLowerCase() == 'development';
}
