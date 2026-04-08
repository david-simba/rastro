class AppConfig {
  final String appEnv;

  const AppConfig({required this.appEnv});

  bool get isProduction => appEnv.trim().toLowerCase() == 'production';
  bool get isDevelopment => appEnv.trim().toLowerCase() == 'development';
}
