import 'package:flutter/material.dart';

import 'app_bottom_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: child,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
