import 'dart:ui';

/// Computes dynamic model-layer scale values from the current camera zoom.
///
/// Relationship: lower zoom (farther out) → higher multiplier (model stays
/// visible); higher zoom (closer in) → lower multiplier (model stays natural).
/// A cubic ease-in-out curve gives perceptually smooth transitions.
///
/// Example results with default settings (minZoom=10, maxZoom=18,
/// minMultiplier=0.5, maxMultiplier=3.0):
///   zoom 10 → 3.0× base scale   (fully zoomed out)
///   zoom 14 → ~1.25× base scale (mid zoom, eased)
///   zoom 18 → 0.5× base scale   (fully zoomed in)
class CameraScaleController {
  /// Base scale from [ModelConfig], used as the 1× reference.
  final List<double> baseScale;

  /// Zoom at which [maxScaleMultiplier] is applied (fully zoomed out).
  final double minZoom;

  /// Zoom at which [minScaleMultiplier] is applied (fully zoomed in).
  final double maxZoom;

  /// Scale multiplier applied when zoom ≥ [maxZoom].
  final double minScaleMultiplier;

  /// Scale multiplier applied when zoom ≤ [minZoom].
  final double maxScaleMultiplier;

  /// Per-axis delta below which a GPU upload is skipped to avoid redundant
  /// style property calls. Lower = more responsive, higher = fewer updates.
  final double updateThreshold;

  List<double> _currentScale;

  CameraScaleController({
    required this.baseScale,
    this.minZoom = 10.0,
    this.maxZoom = 18.0,
    this.minScaleMultiplier = 0.5,
    this.maxScaleMultiplier = 3.0,
    this.updateThreshold = 0.005,
  }) : _currentScale = List.of(baseScale);

  List<double> get currentScale => List.unmodifiable(_currentScale);

  /// Returns the new scale for [zoom], or `null` if the change is below
  /// [updateThreshold] and the GPU upload can be safely skipped.
  List<double>? computeIfChanged(double zoom) {
    final target = _targetScale(zoom);
    if (!_hasChanged(_currentScale, target)) return null;
    _currentScale = target;
    return target;
  }

  List<double> _targetScale(double zoom) {
    final t = ((zoom - minZoom) / (maxZoom - minZoom)).clamp(0.0, 1.0);
    final multiplier =
        lerpDouble(maxScaleMultiplier, minScaleMultiplier, _easeInOut(t))!;
    return baseScale.map((v) => v * multiplier).toList();
  }

  bool _hasChanged(List<double> a, List<double> b) {
    for (int i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > updateThreshold) return true;
    }
    return false;
  }

  static double _easeInOut(double t) {
    if (t < 0.5) return 4 * t * t * t;
    final u = -2 * t + 2;
    return 1 - (u * u * u) / 2;
  }
}
