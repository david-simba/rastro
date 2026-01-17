import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:rastro/ui/widgets/button/index.dart';
import 'package:rastro/ui/widgets/toast/index.dart';

part 'main.g.dart';

@riverpod
String helloWorld(Ref ref) {
  return 'Riverpod and Mapbox Configuration';
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rastro UI')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              text: "Mostrar Error",
              variant: ButtonVariant.danger,
              onPressed: () {
                AppToast.show(
                  context,
                  title: "Error",
                  message: "Opps! Something went wrong.",
                  variant: ToastVariant.error,
                );
              },
            ),
            const SizedBox(height: 10),

            AppButton(
              text: "Mostrar Warning",
              variant: ButtonVariant.black,
              bold: false,
              onPressed: () {
                AppToast.show(
                  context,
                  title: "Warning",
                  message: "Please check your connection.",
                  variant: ToastVariant.warning,
                );
              },
            ),
            const SizedBox(height: 10),

            AppButton(
              text: "Mostrar Success",
              variant: ButtonVariant.primary,
              onPressed: () {
                AppToast.show(
                  context,
                  title: "Success",
                  message: value,
                  variant: ToastVariant.success,
                );
              },
            ),
            const SizedBox(height: 10),

            AppButton(
              text: "Mostrar info",
              variant: ButtonVariant.primary,
              onPressed: () {
                AppToast.show(
                  context,
                  title: "Success",
                  message: value,
                  variant: ToastVariant.info,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}