import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/ui/widgets/button/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
String helloWorld(Ref ref) {
  return 'Riverpod and Mapbox Configuration';
}

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rastro')),
        body: Column(
          children: [
            AppButton(
              text: "Iniciar sesion",
              onPressed: () => print('Test'),
              variant: ButtonVariant.primary,
            ),
            SizedBox(height: 10),
            AppButton(
              text: value,
              onPressed: () => print('Test 2'),
              variant: ButtonVariant.black,
              bold: false,
            ),
          ],
        )
      )
    );
  }
}