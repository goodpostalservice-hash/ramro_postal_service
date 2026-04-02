import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/values/s_dimension.dart';
import '../../../core/values/s_spacing.dart';
import '../controllers/my_subscription_controller.dart';

import 'package:intl/intl.dart';

class MySubscriptionView extends GetView<MySubscriptionController> {
  const MySubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Subscription')),
      body: SingleChildScrollView(
        padding: SSpacing.lgMargin,
        child: Obx(() {
          final package =
              controller.walletResult.value.data?.subscription?.package;
          final sub = controller.walletResult.value.data?.subscription;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Banner
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: SSpacing.lgMargin,
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                      SSpacing.mdW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package?.title ?? 'No Active Plan',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Status: ${sub?.status?.toUpperCase() ?? "N/A"}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SSpacing.mdH,

              // Token & Validity Section
              Text('Subscription Overview', style: theme.textTheme.titleMedium),
              SSpacing.mdH,
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Available Tokens',
                      value: '${sub?.availableTokens ?? 0}',
                      icon: Icons.toll,
                      theme: theme,
                    ),
                  ),
                  SSpacing.mdW,
                  Expanded(
                    child: _SummaryCard(
                      label: 'Valid Until',
                      value: _formatDate(sub?.validUntil),
                      icon: Icons.event_available,
                      theme: theme,
                    ),
                  ),
                ],
              ),
              SSpacing.mdH,

              // Package Details
              Text('Package Details', style: theme.textTheme.titleMedium),
              SSpacing.mdH,
              Card(
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Price',
                      value: '${package?.price ?? '0.00'}',
                      theme: theme,
                    ),
                    _DetailRow(
                      label: 'Package Type',
                      value:
                          package?.packageType?.replaceAll('_', ' ') ?? 'N/A',
                      theme: theme,
                    ),
                    _DetailRow(
                      label: 'Purchase Date',
                      value: _formatDate(sub?.createdAt),
                      theme: theme,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(SDimension.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(SDimension.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.secondary),
            SSpacing.mdH,
            Text(label, style: theme.textTheme.labelSmall),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(SDimension.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: SDimension.md,
            endIndent: SDimension.md,
            color: theme.colorScheme.outlineVariant,
          ),
      ],
    );
  }
}
