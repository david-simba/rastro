import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final busModelPathProvider = FutureProvider<String>((ref) async {
  final data = await rootBundle.load('assets/models/bus.glb');
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/bus.glb');

  if (!await file.exists()) {
    await file.writeAsBytes(data.buffer.asUint8List());
  }
  return 'file://${file.path}';
});