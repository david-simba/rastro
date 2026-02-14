import 'package:live_map/src/domain/types/map_types.dart';

enum ModelLayerStatus { none, loading, loaded, failed }

class ModelsState {
  final List<MapModel> models;
  final MapModel? selectedModel;
  final ModelLayerStatus layerStatus;
  final String? layerError;

  const ModelsState({
    required this.models,
    this.selectedModel,
    this.layerStatus = ModelLayerStatus.none,
    this.layerError,
  });

  ModelsState copyWith({
    List<MapModel>? models,
    MapModel? Function()? selectedModel,
    ModelLayerStatus? layerStatus,
    String? Function()? layerError,
  }) {
    return ModelsState(
      models: models ?? this.models,
      selectedModel:
          selectedModel != null ? selectedModel() : this.selectedModel,
      layerStatus: layerStatus ?? this.layerStatus,
      layerError: layerError != null ? layerError() : this.layerError,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelsState &&
          layerStatus == other.layerStatus &&
          layerError == other.layerError &&
          selectedModel == other.selectedModel &&
          _listEquals(models, other.models);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(models),
        selectedModel,
        layerStatus,
        layerError,
      );

  static bool _listEquals(List<MapModel> a, List<MapModel> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
