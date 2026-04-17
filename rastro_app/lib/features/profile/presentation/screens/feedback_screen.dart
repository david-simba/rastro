import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _sent = true);
    DsToast.show(
      context,
      title: '¡Gracias!',
      message: 'Recibimos tus comentarios',
      variant: ToastVariant.success,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final dsColors = context  .dsColors;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrow_left,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: DsText('Comentarios', variant: TextVariant.subtitle),
        backgroundColor: dsColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DsLayout.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText(
                '¿Cómo podemos mejorar?',
                variant: TextVariant.subtitle,
                color: dsColors.onBackground,
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsText(
                'Tu opinión nos ayuda a hacer Rastro mejor para todos.',
                variant: TextVariant.regular2,
                color: dsColors.muted,
              ),
              SizedBox(height: DsLayout.spacingXxl),
              DsTextField(
                controller: _controller,
                hint: 'Escribí tu comentario...',
                maxLines: 6,
              ),
              SizedBox(height: DsLayout.spacingXxl),
              DsButton(
                text: 'Enviar comentario',
                fullWidth: true,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
