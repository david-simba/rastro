import 'package:design_system/design_system.dart';
import 'package:driver_app/core/routing/app_routes.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:driver_app/features/route_selection/presentation/providers/route_selection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouteSelectionScreen extends ConsumerStatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  ConsumerState<RouteSelectionScreen> createState() =>
      _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends ConsumerState<RouteSelectionScreen> {
  final _vehicleIdController = TextEditingController();
  RouteItem? _selectedRoute;

  @override
  void dispose() {
    _vehicleIdController.dispose();
    super.dispose();
  }

  void _startShift() {
    final vehicleId = _vehicleIdController.text.trim();
    if (vehicleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el ID del vehículo')),
      );
      return;
    }
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una ruta')),
      );
      return;
    }
    context.go(AppRoutes.tracking, extra: {
      'vehicleId': vehicleId,
      'routeId': _selectedRoute!.id,
      'routeName': _selectedRoute!.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeState = ref.watch(routeSelectionProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ruta'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.log_out),
            onPressed: authNotifier.signOut,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText('Configura tu turno', variant: TextVariant.title),
              DsText(
                'Ingresa el ID de tu vehículo y selecciona tu ruta',
                color: DsColors.zinc500,
              ),
              SizedBox(height: DsLayout.spacingXl),
              DsTextField(
                hint: 'ID del vehículo (ej: bus_001)',
                leadingIcon: LucideIcons.bus,
                controller: _vehicleIdController,
              ),
              SizedBox(height: DsLayout.spacingXl),
              DsText('Ruta asignada', variant: TextVariant.medium),
              SizedBox(height: DsLayout.spacingMd),
              Expanded(
                child: switch (routeState) {
                  RouteSelectionLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  RouteSelectionError(:final message) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DsText(message, color: DsColors.red500),
                          SizedBox(height: DsLayout.spacingMd),
                          DsButton(
                            text: 'Reintentar',
                            onPressed: ref
                                .read(routeSelectionProvider.notifier)
                                .reload,
                          ),
                        ],
                      ),
                    ),
                  RouteSelectionLoaded(:final routes) => ListView.separated(
                      itemCount: routes.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: DsLayout.spacingSm),
                      itemBuilder: (context, index) {
                        final route = routes[index];
                        final isSelected = _selectedRoute?.id == route.id;
                        return _RouteCard(
                          route: route,
                          isSelected: isSelected,
                          onTap: () =>
                              setState(() => _selectedRoute = route),
                        );
                      },
                    ),
                },
              ),
              SizedBox(height: DsLayout.spacingLg),
              DsGradientButton(
                text: 'Iniciar turno',
                height: 46,
                fullWidth: true,
                colors: [DsColors.blue600, DsColors.blue500],
                onPressed: _startShift,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  final RouteItem route;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? DsColors.blue500.withValues(alpha: 0.1)
              : context.dsColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? DsColors.blue500 : context.dsColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.route,
              size: 18,
              color: isSelected ? DsColors.blue500 : DsColors.zinc500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DsText(
                route.name,
                variant: TextVariant.medium,
                color: isSelected ? DsColors.blue500 : null,
              ),
            ),
            if (isSelected)
              const Icon(LucideIcons.circle_check,
                  size: 18, color: DsColors.blue500),
          ],
        ),
      ),
    );
  }
}
