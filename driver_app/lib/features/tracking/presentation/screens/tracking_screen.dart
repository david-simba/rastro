import 'package:design_system/design_system.dart';
import 'package:driver_app/core/routing/app_routes.dart';
import 'package:driver_app/features/tracking/presentation/providers/tracking_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({
    required this.vehicleId,
    required this.routeId,
    required this.routeName,
    super.key,
  });

  final String vehicleId;
  final String routeId;
  final String routeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingState = ref.watch(trackingProvider);
    final notifier = ref.read(trackingProvider.notifier);
    final isActive = trackingState is TrackingActive;

    return PopScope(
      canPop: !isActive,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && isActive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Detén el tracking antes de salir'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tracking'),
          leading: isActive
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(LucideIcons.arrow_left),
                  onPressed: () => context.go(AppRoutes.routeSelection),
                ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoCard(
                  icon: LucideIcons.bus,
                  label: 'Vehículo',
                  value: vehicleId,
                ),
                SizedBox(height: DsLayout.spacingMd),
                _InfoCard(
                  icon: LucideIcons.route,
                  label: 'Ruta',
                  value: routeName,
                ),
                SizedBox(height: DsLayout.spacingXl),
                _StatusCard(state: trackingState),
                const Spacer(),
                switch (trackingState) {
                  TrackingError(:final message) => Column(
                      children: [
                        DsText(message,
                            color: DsColors.red500,
                            variant: TextVariant.regular2),
                        SizedBox(height: DsLayout.spacingMd),
                        DsGradientButton(
                          text: 'Reintentar',
                          height: 46,
                          fullWidth: true,
                          colors: [DsColors.blue600, DsColors.blue500],
                          onPressed: () => notifier.startTracking(
                            vehicleId: vehicleId,
                            routeId: routeId,
                          ),
                        ),
                      ],
                    ),
                  TrackingActive() => DsButton(
                      text: 'Detener tracking',
                      height: 46,
                      fullWidth: true,
                      variant: ButtonVariant.outlined,
                      color: DsColors.red500,
                      textColor: DsColors.red500,
                      leading: const Icon(LucideIcons.square_stop,
                          size: 18, color: DsColors.red500),
                      onPressed: notifier.stopTracking,
                    ),
                  _ => DsGradientButton(
                      text: 'Iniciar tracking',
                      height: 46,
                      fullWidth: true,
                      colors: [DsColors.blue600, DsColors.blue500],
                      onPressed: () => notifier.startTracking(
                        vehicleId: vehicleId,
                        routeId: routeId,
                      ),
                    ),
                },
                SizedBox(height: DsLayout.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.dsColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dsColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: DsColors.zinc500),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText(label,
                  variant: TextVariant.regular2, color: DsColors.zinc500),
              DsText(value, variant: TextVariant.medium),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final TrackingState state;

  @override
  Widget build(BuildContext context) {
    final (color, icon, title, subtitle) = switch (state) {
      TrackingActive(:final position) => (
          DsColors.green500,
          LucideIcons.navigation,
          'Transmitiendo',
          'Lat: ${position.latitude.toStringAsFixed(6)}\nLng: ${position.longitude.toStringAsFixed(6)}',
        ),
      TrackingError() => (
          DsColors.red500,
          LucideIcons.triangle_alert,
          'Error',
          'No se pudo iniciar el tracking',
        ),
      _ => (
          DsColors.zinc500,
          LucideIcons.navigation_off,
          'Sin transmitir',
          'Presiona Iniciar tracking para comenzar',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: color),
          SizedBox(height: DsLayout.spacingMd),
          DsText(title, variant: TextVariant.title, color: color),
          SizedBox(height: DsLayout.spacingSm),
          DsText(
            subtitle,
            variant: TextVariant.regular2,
            color: DsColors.zinc500,
          ),
        ],
      ),
    );
  }
}
