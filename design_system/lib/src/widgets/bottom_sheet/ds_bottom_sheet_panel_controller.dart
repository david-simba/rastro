import 'package:design_system/src/widgets/bottom_sheet/ds_bottom_sheet_panel.dart';

class DsBottomSheetPanelController {
  DsBottomSheetPanelState? _state;

  void attach(DsBottomSheetPanelState state) => _state = state;
  void detach() => _state = null;

  double get maxHeight => _state?.widget.maxHeight ?? double.infinity;

  void snapToMin() => _state?.snapToExternal(_state!.widget.minHeight);
  void snapToNormal() => _state?.snapToExternal(_state!.widget.normalHeight);
  void snapToMax() => _state?.snapToExternal(_state!.widget.maxHeight);
}
