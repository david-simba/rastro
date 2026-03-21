import 'package:live_map/src/domain/entities/zoom_scale_config.dart';

class ModelConfig {
  final String modelPath;
  final List<double> scale;
  final List<double> rotation;

  /// Optional zoom-based scaling. When `null`, [scale] is static.
  final ZoomScaleConfig? zoomScale;

  const ModelConfig({
    required this.modelPath,
    required this.scale,
    required this.rotation,
    this.zoomScale,
  });
}
