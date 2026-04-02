import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  int _selectedTab = 0;

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: DsLayout.spacingLg),
              DsText(
                'Rutas',
                variant: TextVariant.title,
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsTabSelector(
                tabs: const ['Todas', 'Favoritas'],
                selectedIndex: _selectedTab,
                onTabSelected: (index) => setState(() => _selectedTab = index),
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsListCard(
                title: 'Translatinos',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.yellow400,
                trailing: Icon(LucideIcons.chevron_right, color: DsColors.zinc300),
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsListCard(
                title: 'Transplaneta',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.orange400,
                trailing: Icon(LucideIcons.chevron_right, color: DsColors.zinc300),
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsListCard(
                title: 'Los Chillos',
                subtitle: 'Quitumbe → Sangolqui',
                accentColor: DsColors.green700,
                trailing: Icon(LucideIcons.chevron_right, color: DsColors.zinc300),
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsListCard(
                title: 'Ecovia',
                badge: 'E2',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.blue500,
                trailing: Icon(LucideIcons.chevron_right, color: DsColors.zinc300),
              ),
              SizedBox(height: DsLayout.spacingXxl),
            ],
          ),
        ),
      ),
    );
  }
}
