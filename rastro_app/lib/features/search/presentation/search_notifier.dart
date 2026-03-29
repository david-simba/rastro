import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

class SearchNotifier extends Notifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() {
      _debounce?.cancel();
    });

    return '';
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = query;
    });
  }
}