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
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: context.dsColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ...previousChildren,
                    ?currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                final isRegister = child.key == ValueKey(const ValueKey('register'));
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, isRegister ? -1 : 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey(child.key),
                color: context.dsColors.background,
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
