import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/s_dimension.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Order #${controller.orderResult.value.data?.orderUuid?.substring(4, 12)}',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SDimension.md),
        child: Obx(() {
          final order = controller.orderResult.value.data;
          final user = order?.user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status & Tracking Header
              Card(
                child: Padding(
                  padding: EdgeInsets.all(SDimension.lg),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Badge(
                            label: order?.status?.toUpperCase() ?? 'PENDING',
                            theme: theme,
                          ),
                          Text(
                            order?.vechicleType?.toUpperCase() ?? 'BIKE',
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      SizedBox(height: SDimension.lg),
                      Text(
                        'Tracking Number',
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        order?.trackingNumber ?? 'N/A',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SDimension.lg),

              // Delivery Points
              Text('Delivery Details', style: theme.textTheme.titleMedium),
              SizedBox(height: SDimension.sm),
              Card(
                child: Column(
                  children: [
                    _LocationTile(
                      title: 'Sender / Pickup',
                      subtitle:
                          '${user?.firstName ?? 'Unknown'} (${user?.phone ?? ''})',
                      icon: Icons.radio_button_checked,
                      iconColor: theme.colorScheme.primary,
                      theme: theme,
                    ),
                    _LocationTile(
                      title: 'Receiver / Delivery',
                      subtitle:
                          '${order?.receiverName} (${order?.receiverPhone})',
                      icon: Icons.location_on,
                      iconColor: theme.colorScheme.error,
                      theme: theme,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: SDimension.lg),

              // Payment Summary
              Text('Payment Summary', style: theme.textTheme.titleMedium),
              SizedBox(height: SDimension.sm),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(SDimension.md),
                  child: Column(
                    children: [
                      _PriceRow(
                        label: 'Delivery Fee',
                        value: order?.deliveryFee,
                        theme: theme,
                      ),
                      _PriceRow(
                        label: 'Tax',
                        value: order?.taxAmount,
                        theme: theme,
                      ),
                      _PriceRow(
                        label: 'Discount',
                        value: '-${order?.discountAmount}',
                        theme: theme,
                      ),
                      Divider(color: theme.colorScheme.outlineVariant),
                      _PriceRow(
                        label: 'Total Amount',
                        value: order?.totalAmount,
                        theme: theme,
                        isTotal: true,
                      ),
                      SizedBox(height: SDimension.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Method: ${order?.paymentMethod?.toUpperCase()}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            'Status: ${order?.paymentStatus?.toUpperCase()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SDimension.lg),

              // Additional Info
              Text('Specifications', style: theme.textTheme.titleMedium),
              SizedBox(height: SDimension.sm),
              Wrap(
                spacing: SDimension.sm,
                runSpacing: SDimension.sm,
                children: [
                  _InfoChip(
                    label: 'Priority: ${order?.orderPriority}',
                    theme: theme,
                  ),
                  _InfoChip(
                    label: 'Fragile: ${order?.fragileHandling}',
                    theme: theme,
                  ),
                  _InfoChip(
                    label:
                        'Scope: ${order?.deliveryScope?.replaceAll('_', ' ')}',
                    theme: theme,
                  ),
                  _InfoChip(label: 'Payer: ${order?.payeer}', theme: theme),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final ThemeData theme;
  final bool isLast;

  const _LocationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.theme,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: theme.textTheme.labelMedium),
      subtitle: Text(subtitle, style: theme.textTheme.bodyLarge),
      contentPadding: EdgeInsets.symmetric(
        horizontal: SDimension.md,
        vertical: SDimension.sm,
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String? value;
  final ThemeData theme;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.theme,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SDimension.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value ?? '0.00',
            style: isTotal
                ? theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final ThemeData theme;

  const _Badge({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SDimension.md,
        vertical: SDimension.sm / 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(SDimension.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final ThemeData theme;

  const _InfoChip({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SDimension.sm,
        vertical: SDimension.sm / 2,
      ),
      decoration: BoxDecoration(
        border: Border?.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(SDimension.sm),
      ),
      child: Text(label, style: theme.textTheme.bodySmall),
    );
  }
}
