import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        'Rastro ',
        variant: TextVariant.title,
        bold: true,
      ),
    );
  }
}
