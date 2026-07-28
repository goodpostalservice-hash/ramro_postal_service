import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/error/toast.dart';
import '../../data/models/notification_response.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        backgroundColor: appTheme.white,
        elevation: 0.5,
        centerTitle: false,
        titleSpacing: AppSpacing.screenHorizontal,
        iconTheme: IconThemeData(color: appTheme.black),
        title: Text(
          'Notification',
          style: CustomTextStyles.titleLargeBlack20_500,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Hook your API if you support "mark all".
              // For now, keep the UX snappy:
              showSuccessMessage('Marked all as read.');
            },
            child: Text(
              'Mark all as read',
              style: CustomTextStyles.bodyMediumGrey_14_500,
            ),
          ),
          AppSpacing.horizontalGapSm,
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final raw = controller.resultNotificationList;
        if (raw.isEmpty) return const _EmptyState();

        // Map model -> VM and group
        final vms = raw.map(NotifVM.fromModel).toList();
        final grouped = _groupByDay(vms);

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: grouped.length,
          itemBuilder: (context, sectionIndex) {
            final section = grouped[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(label: section.label),
                ...List.generate(section.items.length, (i) {
                  final n = section.items[i];
                  return _SlidableNotificationTile(
                    vm: n,
                    onDelete: () {
                      // find the live index in your GetX list by id (safe if grouped)
                      final idx = controller.resultNotificationList.indexWhere(
                        (e) => e.id == n.id,
                      );
                      if (idx != -1) {
                        // controller.deleteNotification(n.id, idx);
                      }
                    },
                  );
                }),
              ],
            );
          },
        );
      }),
    );
  }
}

/// ---------- View model + grouping ----------

class NotifVM {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String initials;
  final String? ctaLabel;
  final VoidCallback? onTapCta;

  NotifVM({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.initials,
    this.ctaLabel,
    this.onTapCta,
  });

  static DateTime _parseDateSafe(String? s) {
    if (s == null || s.trim().isEmpty) return DateTime.now();
    // Try ISO first, then common "yyyy-MM-dd HH:mm:ss"
    try {
      return DateTime.parse(s);
    } catch (_) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(s);
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  static String _initialsFrom(String primary, String fallback) {
    final text = (primary.isNotEmpty ? primary : fallback).trim();
    final parts = text.split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'AB';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].isNotEmpty ? parts[0][0] : 'A').toUpperCase() +
        (parts[1].isNotEmpty ? parts[1][0] : 'B').toUpperCase();
  }

  factory NotifVM.fromModel(MyNotificationResponseModel m) {
    final id = (m.id ?? '').toString();
    final title = (m.title ?? '').toString();
    final body = (m.body ?? '').toString();
    final date = _parseDateSafe(m.createdAt);

    // Optional chip if you add types later:
    String? ctaLabel;
    VoidCallback? onTapCta;
    // Example:
    // if (m.type == 'navigate') { ctaLabel = 'Navigate'; onTapCta = () => Get.toNamed('/map'); }

    return NotifVM(
      id: id,
      title: title,
      body: body,
      date: date,
      initials: _initialsFrom(title, body),
      ctaLabel: ctaLabel,
      onTapCta: onTapCta,
    );
  }
}

class _Section {
  final String label;
  final List<NotifVM> items;
  _Section(this.label, this.items);
}

List<_Section> _groupByDay(List<NotifVM> items) {
  final now = DateTime.now();
  bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  final today = <NotifVM>[];
  final yesterday = <NotifVM>[];
  final earlier = <NotifVM>[];

  for (final n in items) {
    if (sameDay(n.date, now)) {
      today.add(n);
    } else if (sameDay(n.date, now.subtract(const Duration(days: 1)))) {
      yesterday.add(n);
    } else {
      earlier.add(n);
    }
  }

  final sections = <_Section>[];
  if (today.isNotEmpty) sections.add(_Section('Today', today));
  if (yesterday.isNotEmpty) sections.add(_Section('Yesterday', yesterday));
  if (earlier.isNotEmpty) sections.add(_Section('Earlier', earlier));
  return sections;
}

/// ---------- UI pieces ----------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.gray100,
      width: double.infinity,
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm + AppSpacing.xxs,
      ),
      child: Text(label, style: CustomTextStyles.bodyMediumGray14_400),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.vm, this.onDelete});

  final NotifVM vm;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.white,
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InitialsCircle(text: vm.initials),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${vm.title} ',
                        style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: vm.body,
                        style: CustomTextStyles.bodyMediumGray14_400,
                      ),
                    ],
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: AppSizes.iconMd,
                    color: appTheme.gray500,
                  ),
                  onPressed: onDelete,
                  splashRadius: 20,
                ),
            ],
          ),
          if (vm.ctaLabel != null && vm.ctaLabel!.trim().isNotEmpty) ...[
            AppSpacing.gapSm,
            Align(
              alignment: Alignment.centerLeft,
              child: _CtaChip(label: vm.ctaLabel!, onTap: vm.onTapCta),
            ),
          ],
          AppSpacing.gapSm,
          // const Divider(height: 1),
        ],
      ),
    );
  }
}

class _InitialsCircle extends StatelessWidget {
  const _InitialsCircle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppSizes.iconMd,
      backgroundColor: context.semantic.success,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: context.semantic.onSuccess,
          fontSize: AppTheme.light.textTheme.bodyMedium?.fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CtaChip extends StatelessWidget {
  const _CtaChip({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: appTheme.orangeBase,
        side: BorderSide(color: appTheme.orangeBase),
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.md + AppSpacing.xxs,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
      child: Text(
        label,
        style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: AppSpacing.jumbo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can swap for your asset/3D bell here
            SvgPicture.asset(AppAssets.iconsSvgNoNotification),
            AppSpacing.gapMd,
            Text(
              'No Notification',
              style: CustomTextStyles.titleLargeBlack20_500,
            ),
            AppSpacing.gapXs,
            Text(
              "We'll notify you when something arrives.",
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMediumGray14_400,
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidableNotificationTile extends StatelessWidget {
  const _SlidableNotificationTile({required this.vm, this.onDelete});

  final NotifVM vm;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(vm.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => Slidable.of(context)?.close(),
            backgroundColor: context.semantic.info,
            foregroundColor: context.semantic.onInfo,
            icon: Icons.close,
            label: 'Close',
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: context.semantic.danger,
            foregroundColor: context.semantic.onDanger,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        color: appTheme.white,
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.md,
        ),
        margin: AppSpacing.only(bottom: AppSpacing.xxs),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InitialsCircle(text: vm.initials),
                AppSpacing.horizontalGapMd,
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${vm.title} ',
                          style: CustomTextStyles.bodyMediumBlack14_400,
                        ),
                        TextSpan(
                          text: vm.body,
                          style: CustomTextStyles.bodyMediumGray14_400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (vm.ctaLabel != null && vm.ctaLabel!.trim().isNotEmpty) ...[
              AppSpacing.gapSm,
              Align(
                alignment: Alignment.centerLeft,
                child: _CtaChip(label: vm.ctaLabel!, onTap: vm.onTapCta),
              ),
            ],
            AppSpacing.gapSm,
          ],
        ),
      ),
    );
  }
}
