import 'dart:async';
import 'package:flutter/material.dart';
import 'toast_animation.dart';
import 'toast_variant.dart';

class AppToast {
  AppToast._();

  static OverlayEntry? _currentToast;
  static Timer? _timer;
  static final GlobalKey<ToastAnimationState> _toastKey = GlobalKey();

  static void show(
    BuildContext context, {
      required String title,
      required String message,
      ToastVariant variant = ToastVariant.info,
      Duration duration = const Duration(seconds: 4),
    }) {
    _dismissCurrent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context, rootOverlay: true);

      _currentToast = OverlayEntry(
        builder: (context) => ToastAnimation(
          key: _toastKey,
          title: title,
          message: message,
          variant: variant,
          onDismiss: dismiss,
        ),
      );

      overlay.insert(_currentToast!);
      _timer = Timer(duration, () => dismiss());
    });
  }

  static void dismiss() async {
    if (_currentToast == null) return;

    _timer?.cancel();
    _timer = null;

    await _toastKey.currentState?.hide();

    _currentToast?.remove();
    _currentToast = null;
  }

  static void _dismissCurrent() {
    if (_currentToast != null) {
      _timer?.cancel();
      _currentToast?.remove();
      _currentToast = null;
    }
  }
}