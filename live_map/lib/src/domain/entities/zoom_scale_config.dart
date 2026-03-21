class ZoomScaleConfig {
  /// Zoom level at which [maxScaleMultiplier] is applied (fully zoomed out).
  final double minZoom;

  /// Zoom level at which [minScaleMultiplier] is applied (fully zoomed in).
  final double maxZoom;

  /// Scale multiplier applied when zoom ≥ [maxZoom]. Default: 0.5.
  final double minScaleMultiplier;

  /// Scale multiplier applied when zoom ≤ [minZoom]. Default: 3.0.
  final double maxScaleMultiplier;

  const ZoomScaleConfig({
    this.minZoom = 10.0,
    this.maxZoom = 18.0,
    this.minScaleMultiplier = 0.5,
    this.maxScaleMultiplier = 3.0,
  });
}
