import 'package:driver_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:driver_app/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:driver_app/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AuthHeader(),
          AuthSheet(child: LoginForm()),
        ],
      ),
    );
  }
}
