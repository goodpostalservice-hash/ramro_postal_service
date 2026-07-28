import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/earning/presentation/controllers/earning_controller.dart';

import '../../../../core/widgets/custom_app_widget.dart';

class EarningDashboardView extends GetView<EarningController> {
  const EarningDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: backAppBar("Earnings Dashboard", context),
      body: SingleChildScrollView(
        padding: AppSpacing.cardInsets.copyWith(
          left: AppSpacing.md,
          top: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        child: Obx(() {
          var todayEarnings =
              controller.todayEarningResult.value.todayEarnings ?? 0.0;
          var totalEarnings =
              controller.totalEarningResult.value.earnings ?? 0.0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Earnings Hero Card
              Card(
                margin: EdgeInsets.zero,
                color: theme.colorScheme.primary,
                child: Container(
                  width: double.infinity,
                  padding: AppSpacing.cardInsets,
                  child: Column(
                    children: [
                      Text(
                        'Total Earnings',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        ),
                      ),
                      AppSpacing.gapSm,
                      Text(
                        '\$ $totalEarnings',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapLg,

              // Daily Stats Section
              Text('Performance Overview', style: theme.textTheme.titleMedium),
              AppSpacing.gapSm,

              // Today's Earning Card
              Card(
                child: ListTile(
                  contentPadding: AppSpacing.cardInsets.copyWith(
                    left: AppSpacing.md,
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.md,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.trending_up,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    'Today\'s Earnings',
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    '\$${todayEarnings.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              AppSpacing.gapMd,

              // Insight Placeholder / Empty State
              if (totalEarnings == 0)
                _EmptyEarningsPlaceholder(theme: theme)
              else
                _RecentActivitySection(theme: theme),
            ],
          );
        }),
      ),
    );
  }
}

class _EmptyEarningsPlaceholder extends StatelessWidget {
  final ThemeData theme;

  const _EmptyEarningsPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.symmetric(vertical: AppSpacing.jumbo),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            AppSpacing.gapMd,
            Text(
              'No earnings yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            Text(
              'Your financial summary will appear here.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final ThemeData theme;

  const _RecentActivitySection({required this.theme});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder for future activity lists
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: theme.textTheme.titleMedium),
        AppSpacing.gapSm,
        Card(
          child: Padding(
            padding: AppSpacing.cardInsets.copyWith(
              left: AppSpacing.md,
              top: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: Text(
              'Activities will be listed as you complete tasks.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
