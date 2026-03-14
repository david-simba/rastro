import 'package:flutter/material.dart';

class DsImageCard extends StatelessWidget {
  final ImageProvider backgroundImage;
  final Widget? child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final bool withOverlay;

  const DsImageCard({
    required this.backgroundImage,
    this.child,
    this.borderRadius = 16,
    this.padding,
    this.height,
    this.width,
    this.withOverlay = false,
    super.key,
  });

  factory DsImageCard.url({
    required String imageUrl,
    double borderRadius = 16,
    EdgeInsetsGeometry? padding,
    double? height,
    double? width,
    bool withOverlay = false,
    Key? key,
    Widget? child,
  }) {
    return DsImageCard(
      backgroundImage: NetworkImage(imageUrl),
      borderRadius: borderRadius,
      padding: padding,
      height: height,
      width: width,
      withOverlay: withOverlay,
      key: key,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            if (withOverlay)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
              ),
            if (child != null)
              Positioned.fill(
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
