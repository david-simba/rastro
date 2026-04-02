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

  static const double _horizontalPadding = 24.0;

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
              SizedBox(height: DsLayout.spacingLg),
              DsText(
                "Hola, Team!",
                variant: TextVariant.title,
              ),
              DsText(
                "Encuentra tu ruta",
                variant: TextVariant.regular2,
                color: DsColors.zinc500,
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsSearchBar(
                hintText: "Buscar bus, parada, ruta...",
                controller: controller,
                onChanged: (query) {
                  ref.read(searchProvider.notifier).search(query);
                },
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsGradientCard(
                colors: [DsColors.blue500, DsColors.blue700],
                end: Alignment.bottomRight,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: DsLayout.spacingXl, horizontal: DsLayout.spacingXxl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft, leadingIcon: Icons.circle, iconSize: 8,),
                        SizedBox(height: DsLayout.spacingMd),
                        DsText("Próximo bus", variant: TextVariant.medium2),
                        SizedBox(height: DsLayout.spacingXs),
                        DsText("Transplaneta", variant: TextVariant.title),
                        SizedBox(height: DsLayout.spacingMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DsText(
                              "Llega en 3 min",
                              variant: TextVariant.medium2,
                            ),
                            DsButton(
                              text: "Ver en mapa",
                              height: 36,
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () => context.go(AppRoutes.map),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
              SizedBox(height: DsLayout.spacingLg),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: DsLayout.spacingSm
                ),
                child: Row(
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
                      backgroundColor: DsColors.blue600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: DsLayout.spacingXl),
              const SectionSeparator(
                label: 'Rutas Activas',
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsListCard(
                title: 'Translatinos',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.yellow400,
                trailing: DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft,),
              ),
              SizedBox(height: DsLayout.spacingSm),DsListCard(
                title: 'Transplaneta',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.orange400,
                trailing: DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft,),
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsListCard(
                title: 'Los Chillos',
                subtitle: 'Quitumbe → Sangolqui',
                accentColor: DsColors.green700,
                trailing: DsBadge(label: 'Estan robando 🗣', color: DsColors.red500, variant: BadgeVariant.soft,),
              ),
              SizedBox(height: DsLayout.spacingSm),
              DsListCard(
                title: 'Ecovia',
                badge: 'E2',
                subtitle: 'Rio Coca → Quitumbe',
                accentColor: DsColors.blue500,
                trailing: DsBadge(label: 'En vivo', color: DsColors.green500, variant: BadgeVariant.soft,),
              ),
              SizedBox(height: DsLayout.spacingXl),
              const SectionSeparator(
                label: 'Paradas Cercanas',
              ),
              SizedBox(height: DsLayout.spacingLg),
              Row(
                children: [
                  Expanded(
                    child: DsInfoCard(
                      icon: Icon(LucideIcons.bus_front, color: DsColors.blue500),
                      title: 'La Marín',
                      footer: Row(
                        children: [
                          DsBadge(label: 'E35', variant: BadgeVariant.soft),
                          SizedBox(width: DsLayout.spacingSm),
                          DsBadge(label: 'C1', variant: BadgeVariant.solid),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: DsLayout.spacingMd),
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
              SizedBox(height: DsLayout.spacingXxl),
            ],
          ),
        ),
      ),
    );
  }
}