import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/home/presentation/widgets/section_separator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;

  static const double _horizontalPadding = 20.0;

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              DsSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 24),
              const SectionSeparator(
                label: 'Mapa en vivo',
                trailing: DsBadge(
                  label: "3 buses cerca de ti",
                  leadingIcon: Icons.circle,
                  iconSize: 8,
                  variant: BadgeVariant.soft,
                  color: DsColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              DsImageCard(
                image: Image.asset('assets/images/map_preview_card.png', fit: BoxFit.cover, width: double.infinity, height: 150),
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(LucideIcons.map_pin, size: 16),
                      SizedBox(width: 4),
                      DsText('Quito, Ecuador', bold: true,),
                    ]),
                    DsButton(
                      text: 'Ver mapa',
                      leadingIcon: LucideIcons.navigation,
                      onPressed: () => context.go(AppRoutes.map),
                      bold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionSeparator(
                label: 'Rutas Activas',
              ),
              const SizedBox(height: 16),
              DsListCard(
                title: 'Ecovia',
                subtitle: 'Rio Coca → Quitumbe',
                leading: Icon(LucideIcons.bus, color: DsColors.primary),
                trailing: DsBadge(label: 'En vivo', color: DsColors.success, variant: BadgeVariant.soft,),
              ),
              const SizedBox(height: 10),
              DsListCard(
                title: 'Ecovia',
                subtitle: 'Rio Coca → Quitumbe',
                leading: Icon(LucideIcons.bus, color: DsColors.primary),
                trailing: DsBadge(label: 'En vivo', color: DsColors.success, variant: BadgeVariant.soft,),
              ),
              const SizedBox(height: 10),
              DsListCard(
                title: 'Los Chillos',
                subtitle: 'Quitumbe → Sangolqui',
                leading: Icon(LucideIcons.bus, color: DsColors.danger),
                trailing: DsBadge(label: 'Estan robando 🗣', color: DsColors.danger, variant: BadgeVariant.soft,),
              ),
              const SizedBox(height: 24),
              const SectionSeparator(
                label: 'Paradas Cercanas',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DsInfoCard(
                      icon: Icon(LucideIcons.bus_front, color: DsColors.primary),
                      title: 'La Marín',
                      footer: Row(
                        children: [
                          DsBadge(label: 'E35', variant: BadgeVariant.soft),
                          SizedBox(width: 6),
                          DsBadge(label: 'C1', variant: BadgeVariant.solid),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DsInfoCard(
                      icon: Icon(LucideIcons.bus_front, color: DsColors.primary),
                      title: 'La Cocha',
                      footer: Row(
                        children: [
                          DsBadge(label: 'Translatinos', variant: BadgeVariant.soft),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
