import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DsText('Perfil', variant: TextVariant.title),
      ),
    );
  }
}
