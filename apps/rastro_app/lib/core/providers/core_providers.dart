import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rastro/core/config/app_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});
