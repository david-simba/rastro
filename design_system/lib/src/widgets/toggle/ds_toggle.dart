import 'package:flutter/material.dart';
import '../../theme/ds_colors.dart';
import '../../theme/ds_layout.dart';

class DsToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData onIcon;
  final IconData offIcon;
  final Color? activeColor;

  const DsToggle({
    required this.value,
    required this.onChanged,
    this.onIcon = Icons.light_mode,
    this.offIcon = Icons.dark_mode,
    this.activeColor,
    super.key,
  });

  static const double _width = 46;
  static const double _height = 26;
  static const double _thumbSize = 20;
  static const double _padding = 3;
  static const _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final activeTrack = activeColor ?? DsColors.blue500;
    final inactiveTrack = DsColors.zinc200;
    final trackColor = value ? activeTrack : inactiveTrack;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: _duration,
        curve: Curves.easeInOut,
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(DsLayout.radiusFull),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: _duration,
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(_padding),
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    color: DsColors.white,
                    borderRadius: BorderRadius.circular(DsLayout.radiusFull),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      value ? onIcon : offIcon,
                      key: ValueKey(value),
                      size: 12,
                      color: trackColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
