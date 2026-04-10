import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ramro_postal_service/app/core/values/s_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/wallet_controller.dart';

import 'package:intl/intl.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Details')),
      body: SingleChildScrollView(
        padding: SSpacing.lgMargin,
        child: Obx(() {
          final wallet = controller.walletResult.value.data?.wallet;
          return Skeletonizer(
            enabled: controller.walletResult.value.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Balance Card
                Card(
                  child: Padding(
                    padding: SSpacing.lgMargin,
                    child: Column(
                      children: [
                        Text(
                          'Available Balance',
                          style: theme.textTheme.labelLarge,
                        ),
                        SSpacing.smH,
                        Text(
                          '${wallet?.avilableTokens ?? 0}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SSpacing.smH,
                        Divider(color: theme.colorScheme.outlineVariant),
                        SSpacing.smH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _TokenStat(
                              label: 'Used Tokens',
                              value: '${wallet?.usedTokens ?? 0}',
                              theme: theme,
                            ),
                            _TokenStat(
                              label: 'Wallet ID',
                              value: '#${wallet?.id ?? 'N/A'}',
                              theme: theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SSpacing.lgH,

                // Details Section
                Text('Account Information', style: theme.textTheme.titleMedium),
                SSpacing.smH,
                Card(
                  child: Column(
                    children: [
                      _InfoTile(
                        label: 'User Type',
                        value: wallet?.userType ?? 'Standard',
                        icon: Icons.person_outline,
                        theme: theme,
                      ),
                      _InfoTile(
                        label: 'User ID',
                        value: '${wallet?.userId ?? 'N/A'}',
                        icon: Icons.fingerprint,
                        theme: theme,
                      ),
                      _InfoTile(
                        label: 'Created At',
                        value: _formatDate(wallet?.createdAt),
                        icon: Icons.calendar_today,
                        theme: theme,
                      ),
                      _InfoTile(
                        label: 'Last Updated',
                        value: _formatDate(wallet?.updatedAt),
                        icon: Icons.update,
                        theme: theme,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class _TokenStat extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _TokenStat({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;
  final bool isLast;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: theme.colorScheme.secondary),
          title: Text(label, style: theme.textTheme.bodySmall),
          trailing: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: SSpacing.lgMarginW,
            child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
          ),
      ],
    );
  }
}
