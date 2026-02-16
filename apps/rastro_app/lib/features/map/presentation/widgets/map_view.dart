import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_map/live_map.dart';

import 'package:rastro/features/map/presentation/providers/map_notifier.dart';

class MapView extends ConsumerWidget {
  final void Function(MapModel model)? onModelTap;

  const MapView({this.onModelTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mapNotifierProvider.notifier);

    return LiveMapWidget(
      config: notifier.mapConfig,
      controller: notifier.controller,
      onModelTap: onModelTap,
    );
  }
}
