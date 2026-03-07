import 'package:flutter/material.dart';

import '../../theme/colors.dart';

const double _kHeight = 52.0;
const double _kBorderRadius = 26.0;
const double _kHorizontalPadding = 16.0;
const double _kIconSize = 20.0;
const double _kIconSpacing = 8.0;

const Color _kBackgroundColor = Color(0xFFFFFFFF);
const Color _kSearchIconColor = Color(0xFF9CA3AF);
const Color _kMicIconColor = Color(0xFF6B7280);
const Color _kHintColor = Color(0xFF9CA3AF);
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
    return Container(
      height: _kHeight,
      decoration: BoxDecoration(
        color: _kBackgroundColor,
        borderRadius: BorderRadius.circular(_kBorderRadius),
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
          const SizedBox(width: _kHorizontalPadding),
          const Icon(
            Icons.search_rounded,
            size: _kIconSize,
            color: _kSearchIconColor,
          ),
          const SizedBox(width: _kIconSpacing),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: _kTextFontSize,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: _kHintColor,
                  fontSize: _kTextFontSize,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: DsColors.primary,
            ),
          ),
          if (onMicTap != null)
            GestureDetector(
              onTap: onMicTap,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
                child: Icon(
                  Icons.mic_none_rounded,
                  size: _kIconSize,
                  color: _kMicIconColor,
                ),
              ),
            )
          else
            const SizedBox(width: _kHorizontalPadding),
        ],
      ),
    );
  }
}
