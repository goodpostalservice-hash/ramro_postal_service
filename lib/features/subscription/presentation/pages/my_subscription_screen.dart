import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_exports.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../routes/app_routes.dart';
import '../../data/models/subscription.dart';
import '../controllers/subscription_controller.dart';

class MySubscriptionScreen extends GetView<SubscriptionController> {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: AppBar(
        backgroundColor: appTheme.gray25,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text(
          'My Subscription',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        if (controller.isGettingMySubscription.value &&
            controller.mySubscription.value == null) {
          return const LoadingState();
        }

        final error = controller.errorMessage.value;
        if (error != null && controller.mySubscription.value == null) {
          return ErrorState(
            title: 'Could not load your subscription',
            message: error,
            onRetry: controller.getMySubscription,
          );
        }

        final subscription = controller.mySubscription.value?.subscription;
        if (subscription == null) {
          return EmptyState(
            title: 'You do not have an active subscription.',
            message: 'Choose a package to get started.',
            icon: Icons.workspace_premium_outlined,
            actionLabel: 'View packages',
            onAction: () => Get.toNamed(AppRoutes.getPackage),
            padding: AppSpacing.pageHorizontalPadding,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getMySubscription,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.only(
              left: AppSpacing.lg,
              top: AppSpacing.md,
              right: AppSpacing.lg,
              bottom: AppSpacing.jumbo,
            ),
            children: [
              _PlanCard(subscription: subscription),
              AppSpacing.gapLg,
              _DetailsCard(subscription: subscription),
              AppSpacing.gapXxl,
              SizedBox(
                height: AppSpacing.superSize,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.getPackage),
                  child: const Text('View available packages'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final package = subscription.package;
    final isActive = subscription.status?.toLowerCase() == 'active';
    final statusColor = isActive
        ? const Color(0xFF16803C)
        : Theme.of(context).colorScheme.error;

    return Container(
      padding: AppSpacing.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF191919), Color(0xFF3A3025)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.circular(AppRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  package?.title?.trim().isNotEmpty == true
                      ? package!.title!
                      : 'Subscription plan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: AppSpacing.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .18),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(
                  _label(subscription.status ?? 'Unknown'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive
                        ? const Color(0xFF75E59A)
                        : const Color(0xFFFFAAAA),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapXxl,
          Text(
            '${subscription.availableTokens ?? 0}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'tokens remaining',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final package = subscription.package;
    return Container(
      padding: AppSpacing.cardInsets,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: appTheme.gray200),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Valid until',
            value: _date(subscription.validUntil),
          ),
          const Divider(height: AppSpacing.jumbo),
          _DetailRow(
            icon: Icons.payments_outlined,
            label: 'Plan price',
            value: package?.price == null ? '—' : 'NPR ${package!.price}',
          ),
          const Divider(height: AppSpacing.jumbo),
          _DetailRow(
            icon: Icons.category_outlined,
            label: 'Package type',
            value: _label(package?.packageType ?? '—'),
          ),
          const Divider(height: AppSpacing.jumbo),
          _DetailRow(
            icon: Icons.confirmation_number_outlined,
            label: 'Included tokens',
            value: '${package?.availableTokens ?? 0}',
          ),
          if (subscription.remarks?.toString().trim().isNotEmpty == true) ...[
            const Divider(height: AppSpacing.jumbo),
            _DetailRow(
              icon: Icons.notes_rounded,
              label: 'Remarks',
              value: subscription.remarks.toString(),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: appTheme.gray600),
        AppSpacing.horizontalGapMd,
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: appTheme.gray600),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

String _date(DateTime? date) =>
    date == null ? '—' : DateFormat('d MMM yyyy').format(date.toLocal());

String _label(String value) {
  if (value == '—') return value;
  return value
      .replaceAll('_', ' ')
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
