import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AuthSheet extends StatelessWidget {
  final Widget child;

  const AuthSheet({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.translate(
        offset: const Offset(0, -24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          decoration: BoxDecoration(
            color: context.dsColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}
