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
///
/// ## Memory model
/// Two pre-allocated buffers are created at construction and reused on every
/// call — zero heap allocations after init. The reference returned by
/// [computeIfChanged] points to the internal buffer; do not hold it across
/// calls.
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

  // Pre-allocated buffers — no List allocation after construction.
  final List<double> _buf;  // working buffer, written in-place on every call
  final List<double> _last; // last scale sent to the GPU, for change detection

  CameraScaleController({
    required this.baseScale,
    this.minZoom = 10.0,
    this.maxZoom = 18.0,
    this.minScaleMultiplier = 0.5,
    this.maxScaleMultiplier = 3.0,
    this.updateThreshold = 0.005,
  })  : _buf  = List.of(baseScale),
        _last = List.of(baseScale);

  List<double> get currentScale => List.unmodifiable(_last);

  /// Writes the scale for [zoom] into the internal buffer and returns that
  /// buffer if any axis changed beyond [updateThreshold]; returns `null`
  /// otherwise, signalling that the GPU upload can be skipped.
  ///
  /// The returned reference is the internal buffer — do not hold it across
  /// calls.
  List<double>? computeIfChanged(double zoom) {
    _fillBuffer(zoom);
    if (!_isDifferent()) return null;
    for (int i = 0; i < _buf.length; i++) {
      _last[i] = _buf[i];
    }
    return _buf;
  }

  /// Writes the target scale for [zoom] into [_buf] without any allocation.
  void _fillBuffer(double zoom) {
    final t = ((zoom - minZoom) / (maxZoom - minZoom)).clamp(0.0, 1.0);
    final multiplier =
        lerpDouble(maxScaleMultiplier, minScaleMultiplier, _easeInOut(t))!;
    for (int i = 0; i < baseScale.length; i++) {
      _buf[i] = baseScale[i] * multiplier;
    }
  }

  bool _isDifferent() {
    for (int i = 0; i < _buf.length; i++) {
      if ((_buf[i] - _last[i]).abs() > updateThreshold) return true;
    }
    return false;
  }

  static double _easeInOut(double t) {
    if (t < 0.5) return 4 * t * t * t;
    final u = -2 * t + 2;
    return 1 - (u * u * u) / 2;
  }
}
