import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/home/presentation/widgets/map_preview_card.dart';
import 'package:rastro/features/home/presentation/widgets/section_separator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;

  static const double _horizontalPadding = 20.0;
  static const Color _backgroundColor = Color(0xFFFBFAF8);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // TODO: ref.read(searchNotifierProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              AppSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 24),
              const SectionSeparator('Your Map'),
              MapPreviewCard(
                onPressed: () => context.go(AppRoutes.map),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
