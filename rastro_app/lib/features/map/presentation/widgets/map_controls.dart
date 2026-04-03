import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';
import 'package:rastro/features/map/presentation/widgets/event_debug_list.dart';

class MapControls extends ConsumerWidget {
  final bool showDebug;
  final MapDimensionMode dimensionMode;

  const MapControls({
    required this.showDebug,
    required this.dimensionMode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mapNotifierProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DsFloatingButton(
          onPressed: notifier.toggleDimension,
          icon: dimensionMode == MapDimensionMode.twoD
              ? Icons.threed_rotation_sharp
              : Icons.layers,
        ),
        const SizedBox(height: 10),
        DsFloatingButton(
          onPressed: notifier.centerOnUser,
          icon: Icons.my_location,
        ),
        const SizedBox(height: 10),
        if (showDebug)
          DsFloatingButton(
            onPressed: () => _showEventDebugSheet(context, notifier),
            variant: ButtonVariant.filled,
            icon: Icons.bug_report,
          ),
      ],
    );
  }

  void _showEventDebugSheet(BuildContext context, MapNotifier notifier) {
    DsBottomSheet.show(
      context: context,
      showCloseButton: true,
      child: EventDebugList(controller: notifier.controller),
    );
  }
}
