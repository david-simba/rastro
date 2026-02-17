import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  static const double _horizontalPadding = 20.0;
  static const double _searchBarTopPadding = 16.0;
  static const EdgeInsets _searchBarPadding = EdgeInsets.fromLTRB(
    _horizontalPadding,
    _searchBarTopPadding,
    _horizontalPadding,
    0,
  );

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: _searchBarPadding,
              child: AppSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: Center(
                child: AppText(
                  'Rastro',
                  variant: TextVariant.title,
                  bold: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
