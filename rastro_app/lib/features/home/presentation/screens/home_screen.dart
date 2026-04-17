import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/core/providers/core_providers.dart';
import 'package:rastro/features/home/presentation/widgets/home_active_vehicles.dart';
import 'package:rastro/features/home/presentation/widgets/home_banner_card.dart';
import 'package:rastro/features/home/presentation/widgets/home_header.dart';
import 'package:rastro/features/home/presentation/widgets/home_nearby_stops.dart';
import 'package:rastro/features/home/presentation/widgets/home_quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDev = ref.watch(appConfigProvider).isDevelopment;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: DsLayout.spacingLg),
              const HomeHeader(),
              SizedBox(height: DsLayout.spacingLg),
              const HomeBannerCard(),
              SizedBox(height: DsLayout.spacingLg),
              const HomeQuickActions(),
              SizedBox(height: DsLayout.spacingXl),
              const HomeActiveVehicles(),
              SizedBox(height: DsLayout.spacingXxl),
            ],
          ),
        ),
      ),
    );
  }
}
