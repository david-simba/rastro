import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DsTabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const DsTabSelector({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (index) {
        final isSelected = index == selectedIndex;
        return Padding(
          padding: EdgeInsets.only(right: index < tabs.length - 1 ? DsLayout.spacingSm : 0),
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: DsLayout.spacingXxl,
                vertical: DsLayout.spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? DsColors.blue500 : DsColors.white,
                borderRadius: DsLayout.borderRadiusFull,
                border: isSelected ? null : Border.all(color: DsColors.zinc200, width: 1),
              ),
              child: DsText(
                tabs[index],
                variant: isSelected ? TextVariant.medium2 : TextVariant.regular2,
                color: isSelected ? DsColors.white : DsColors.zinc700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
