import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/s_dimension.dart';
import '../controllers/earning_dashboard_controller.dart';

class EarningDashboardView extends GetView<EarningDashboardController> {
  const EarningDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Earnings Dashboard')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SDimension.md),
        child: Obx(() {
          var todayEarnings =
              controller.todayEarningResult.value.data?.todayEarnings ?? 0.0;
          var totalEarnings =
              controller.earningResult.value.data?.earnings ?? 0.0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Earnings Hero Card
              Card(
                margin: EdgeInsets.zero,
                color: theme.colorScheme.primary,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(SDimension.lg),
                  child: Column(
                    children: [
                      Text(
                        'Total Earnings',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: SDimension.sm),
                      Text(
                        '\$${totalEarnings.toStringAsFixed(2)}',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SDimension.lg),

              // Daily Stats Section
              Text('Performance Overview', style: theme.textTheme.titleMedium),
              SizedBox(height: SDimension.sm),

              // Today's Earning Card
              Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(SDimension.md),
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
              SizedBox(height: SDimension.md),

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
        padding: EdgeInsets.symmetric(vertical: SDimension.lg * 2),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: SDimension.md),
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
        SizedBox(height: SDimension.sm),
        Card(
          child: Padding(
            padding: EdgeInsets.all(SDimension.md),
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
