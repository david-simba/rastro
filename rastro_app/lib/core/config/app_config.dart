class AppConfig {
  final String appEnv;
  final String mapboxToken;
  final String baseUrl;

  const AppConfig({
    required this.appEnv,
    required this.mapboxToken,
    required this.baseUrl,
  });

  bool get isProduction => appEnv.trim().toLowerCase() == 'production';
  bool get isDevelopment => appEnv.trim().toLowerCase() == 'development';
}
