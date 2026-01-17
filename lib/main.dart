import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/ui/widgets/text/app_text.dart';
import 'package:rastro/ui/widgets/text/index.dart';
import 'package:rastro/ui/widgets/text_field/app_text_field.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
          constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 40,
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppText(
                "Rastro Example Form UI",
                variant: TextVariant.title,
              ),
              SizedBox(height: 30,),
              AppTextField(
                label: value,
                hint: value,
              ),
              SizedBox(height: 20,),
              AppTextField(
                label: "Correo electronico",
                hint: "Hola",
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: "Correo electronico",
                      hint: "Hola",
                      errorText: "Error",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      label: "Contraseña",
                      hint: "Hola",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AppTextField(
                label: "Password",
                hint: "12312",
                obscureText: true,
                maxLines: 1,
              ),
              SizedBox(height: 20),
              AppButton(
                  text: "Submit",
                  variant: ButtonVariant.black,
                  onPressed: () => {
                    AppToast.show(context, title: "Value", message: value, variant: ToastVariant.error)
                  })
            ],
          ),
        )
      ),
    ));
  }
}