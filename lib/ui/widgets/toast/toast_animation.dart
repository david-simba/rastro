import 'package:flutter/material.dart';
import 'package:rastro/ui/widgets/toast/toast_card.dart';
import 'toast_variant.dart';

class ToastAnimation extends StatefulWidget {
  final String title;
  final String message;
  final ToastVariant variant;
  final VoidCallback onDismiss;

  const ToastAnimation({
    required this.title,
    required this.message,
    required this.variant,
    required this.onDismiss,
    super.key,
  });

  @override
  State<ToastAnimation> createState() => ToastAnimationState();
}

class ToastAnimationState extends State<ToastAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  Future<void> hide() async {
    if (!mounted) return;
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Material(
            color: Colors.transparent,
            child: ToastCard(
              title: widget.title,
              message: widget.message,
              variant: widget.variant,
              onClose: widget.onDismiss,
            ),
          ),
        ),
      ),
    );
  }
}