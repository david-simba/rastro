import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';

import 'package:rastro/features/home/presentation/widgets/section_separator.dart';
import 'package:rastro/features/search/presentation/search_controller_provider.dart';
import 'package:rastro/features/search/presentation/search_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const double _horizontalPadding = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              DsText(
                "Hola, Team!",
                variant: TextVariant.title,
              ),
              DsText(
                "Encuentra tu ruta",
                variant: TextVariant.regular2,
                color: DsColors.zinc500,
              ),
              const SizedBox(height: 24),
              DsSearchBar(
                hintText: "Buscar bus, parada, ruta...",
                controller: controller,
                onChanged: (query) {
                  ref.read(searchProvider.notifier).search(query);
                },
              ),
              const SizedBox(height: 24),
              DsImageCard(
                image: Image.asset('assets/images/map_preview_card.png', fit: BoxFit.cover, width: double.infinity, height: 150),
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(LucideIcons.map_pin, size: 16),
                      SizedBox(width: 4),
                      DsText('Quito, Ecuador', variant: TextVariant.medium),
                    ]),
                    DsButton(
                      text: 'Ver mapa',
                      leading: const Icon(LucideIcons.navigation, size: 16),
                      onPressed: () => context.go(AppRoutes.map),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DsCircleButton(
                    onPressed: (){},
                    icon: LucideIcons.map,
                    label: "Mapa"
                  ),
                  DsCircleButton(
                    onPressed: (){},
                    icon: LucideIcons.route,
                    label: "Rutas",
                    backgroundColor: DsColors.green500,
                  ),
                  DsCircleButton(
                    onPressed: (){},
                    icon: LucideIcons.clock_4,
                    label: "Horarios",
                    backgroundColor: DsColors.orange400,
                  ),
                  DsCircleButton(
                    onPressed: (){},
                    icon: LucideIcons.star,
                    label: "Favoritos",
                    backgroundColor: DsColors.purple400,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionSeparator(
                label: 'Rutas Activas',
              ),
              const SizedBox(height: 16),
              DsListCard(
                title: 'Ecovia',
                subtitle: 'Rio Coca → Quitumbe',
                leading: Icon(LucideIcons.bus, color: DsColors.blue500),
                trailing: DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft,),
              ),
              const SizedBox(height: 10),
              DsListCard(
                title: 'Ecovia',
                subtitle: 'Rio Coca → Quitumbe',
                leading: Icon(LucideIcons.bus, color: DsColors.blue500),
                trailing: DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft,),
              ),
              const SizedBox(height: 10),
              DsListCard(
                title: 'Los Chillos',
                subtitle: 'Quitumbe → Sangolqui',
                leading: Icon(LucideIcons.bus, color: DsColors.orange500),
                trailing: DsBadge(label: 'Estan robando 🗣', color: DsColors.orange500, variant: BadgeVariant.soft,),
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
                      icon: Icon(LucideIcons.bus_front, color: DsColors.blue500),
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
                      icon: Icon(LucideIcons.bus_front, color: DsColors.blue500),
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