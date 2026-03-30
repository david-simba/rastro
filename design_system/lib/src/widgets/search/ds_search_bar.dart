import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

const double _kIconSize = 20.0;
const double _kTextFontSize = 14.0;
const double _kShadowBlur = 8.0;
const double _kShadowOpacity = 0.06;
const Offset _kShadowOffset = Offset(0, 2);
const String _kDefaultHint = 'Search places, routes...';

class DsSearchBar extends StatelessWidget {
  const DsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onMicTap,
    this.hintText = _kDefaultHint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onMicTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final dsColors = context.dsColors;

    return Container(
      height: DsLayout.searchBarHeight,
      decoration: BoxDecoration(
        color: dsColors.surface,
        borderRadius: DsLayout.borderRadiusFull,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, _kShadowOpacity),
            blurRadius: _kShadowBlur,
            offset: _kShadowOffset,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: DsLayout.spacingLg),
          Icon(Icons.search_rounded, size: _kIconSize, color: dsColors.muted),
          const SizedBox(width: DsLayout.spacingSm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: _kTextFontSize,
                fontWeight: FontWeight.w400,
                color: dsColors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: dsColors.muted,
                  fontSize: _kTextFontSize,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: DsColors.blue500,
            ),
          ),
          if (onMicTap != null)
            GestureDetector(
              onTap: onMicTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingLg),
                child: Icon(Icons.mic_none_rounded, size: _kIconSize, color: dsColors.muted),
              ),
            )
          else
            const SizedBox(width: DsLayout.spacingLg),
        ],
      ),
    );
  }
}
