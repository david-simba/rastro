import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class MapPreviewCard extends StatelessWidget {
  final VoidCallback onPressed;

  const MapPreviewCard({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DsImageCard(
      backgroundImage: const AssetImage('assets/images/map_preview_card.png'),
      height: 240,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LocationLabel(),
              DsButton(
                text: 'View Live Map',
                onPressed: onPressed,
                width: 172,
                height: 40,
                leftIcon: LucideIcons.navigation,
              ),
            ],
          ),
        ],
      )
    );
  }
}

class _LocationLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          LucideIcons.map_pin,
          size: 16,
          color: Colors.white,
        ),
        const SizedBox(width: 6),
        DsText(
          'Quito',
          bold: true,
          color: Colors.white,
        ),
      ],
    );
  }
}
