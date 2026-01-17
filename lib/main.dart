import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/ui/widgets/text/index.dart';
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
        appBar: AppBar(title: const Text('Quito Mobility')),
        body: Column(
          children: [
            AppText(value, variant: TextVariant.headline, align: TextAlign.center),
            AppText(value, variant: TextVariant.title, align: TextAlign.center, color: Colors.blue),
            AppText(value, variant: TextVariant.subtitle),
            AppText(value, variant: TextVariant.body, bold: true),
            AppText(value, variant: TextVariant.body),
            AppText(value, variant: TextVariant.label, bold: true),
            AppText(value, variant: TextVariant.label),
            AppText(value, variant: TextVariant.caption, bold: true),
            AppText(value, variant: TextVariant.caption),
          ],
        )
      )
    );
  }
}