import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Copies a bundled Flutter asset to a temporary file and returns its
/// `file://` URI. Skips the write if the file already exists on disk.
class AssetLoaderService {
  const AssetLoaderService._();

  static Future<String> loadToTempFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${dir.path}/$fileName');

    if (!await file.exists()) {
      await file.writeAsBytes(data.buffer.asUint8List());
    }
    return 'file://${file.path}';
  }
}
