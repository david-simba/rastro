import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
          onPressed: notifier.centerOnUser,
          icon: LucideIcons.locate,
          iconColor: DsColors.blue500,
        ),
        const SizedBox(height: 10),
        DsFloatingButton(
          onPressed: notifier.toggleDimension,
          icon: dimensionMode == MapDimensionMode.twoD
              ? LucideIcons.box
              : LucideIcons.map,
          iconColor: DsColors.blue500,
        ),
        const SizedBox(height: 10),
        if (showDebug)
          DsFloatingButton(
            onPressed: () => _showEventDebugSheet(context, notifier),
            variant: ButtonVariant.filled,
            icon: LucideIcons.bug,
            iconColor: DsColors.blue500,
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
