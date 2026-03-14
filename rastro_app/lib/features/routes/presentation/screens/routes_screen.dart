import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DsText('Rutas', variant: TextVariant.title, bold: true),
      ),
    );
  }
}
