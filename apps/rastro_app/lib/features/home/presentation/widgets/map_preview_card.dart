import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapPreviewCard extends StatelessWidget {
  final VoidCallback onPressed;

  const MapPreviewCard({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppImageCard(
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
              AppButton(
                text: 'View Live Map',
                onPressed: onPressed,
                width: 172,
                height: 40,
                leftIcon: Icons.near_me_outlined,
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
          Icons.location_on_outlined,
          size: 16,
          color: Colors.white,
        ),
        const SizedBox(width: 6),
        AppText(
          'Quito',
          bold: true,
          color: Colors.white,
        ),
      ],
    );
  }
}
