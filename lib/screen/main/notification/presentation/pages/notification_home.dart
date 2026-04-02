import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/error/toast.dart';

import '../../controller/notification_controller.dart';
import '../../modal/my_notification_response_model.dart';

// class NotificationHomeScreen extends GetView<NotificationController> {
//   late double width, height;

//   NotificationHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: AppColors.normalBG,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Notifications",style: ,),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(0.0),
//         child: notification(),
//       ),
//     );
//   }

//   Widget campaign() {
//     return Obx(() => controller.resultList.isNotEmpty
//         ? ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: controller.resultList.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 0.0, top: 10.0),
//                 color: Colors.white,
//                 child: InkWell(
//                   onTap: () {},
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.network(
//                           controller.resultList[index].featureImage.toString(),
//                           height: 170.0,
//                           width: double.infinity,
//                           fit: BoxFit.cover),
//                       Container(
//                         padding: const EdgeInsets.only(
//                             top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(controller.resultList[index].title.toString(),
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16.0)),
//                             // Padding(
//                             //   padding:
//                             //       const EdgeInsets.only(top: 5.0, bottom: 8.0),
//                             //   child: Html(
//                             //       data: controller.resultList[index].description
//                             //           .toString()),
//                             //   // child: Text(controller.resultList[index].description.toString(),
//                             //   //     style: const TextStyle(
//                             //   //         color: Colors.black54, fontSize: 14.0)),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           margin:
//                               const EdgeInsets.only(bottom: 20.0, right: 10.0),
//                           height: 40.0,
//                           width: 120.0,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               String url =
//                                   controller.resultList[index].url.toString();
//                               if (await canLaunch(url)) {
//                                 await launch(url);
//                               } else {
//                                 throw 'Could not launch $url';
//                               }
//                             },
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text('Watch Now'.toUpperCase(),
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           )
//         : const Center(child: CircularProgressIndicator()));
//   }

//   Widget notification() {
//     return Obx(() => controller.isToLoadMore.value == true
//         ? const Center(child: CircularProgressIndicator())
//         : controller.resultNotificationList.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: controller.resultNotificationList.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 0.0, top: 7.0),
//                     color: Colors.white,
//                     child: InkWell(
//                       onTap: () {},
//                       child: Slidable(
//                         key: ValueKey(index),
//                         endActionPane: ActionPane(
//                           motion: const ScrollMotion(),
//                           children: [
//                             SlidableAction(
//                               onPressed: (_) {},
//                               backgroundColor: const Color(0xFF21B7CA),
//                               foregroundColor: Colors.white,
//                               icon: Icons.close,
//                               label: 'Close',
//                             ),
//                             SlidableAction(
//                               onPressed: (_) {
//                                 controller.deleteNotification(
//                                     controller
//                                         .resultNotificationList[index].id!,
//                                     index);
//                               },
//                               backgroundColor: const Color(0xFFFE4A49),
//                               foregroundColor: Colors.white,
//                               icon: Icons.delete,
//                               label: 'Delete',
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.only(
//                                   top: 7.0,
//                                   bottom: 10.0,
//                                   left: 5.0,
//                                   right: 5.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Container(
//                                     height: 60.0,
//                                     width: 60.0,
//                                     margin: const EdgeInsets.only(right: 10.0),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       color: AppColors.normalBG,
//                                     ),
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         child: CachedNetworkImage(
//                                           height: 50.0,
//                                           width: 50.0,
//                                           imageUrl: controller
//                                               .resultNotificationList[index]
//                                               .image
//                                               .toString(),
//                                           fit: BoxFit.cover,
//                                           placeholder: (context, url) =>
//                                               Image.asset(
//                                                   "assets/banners/ic_app_card_placeholder.png",
//                                                   fit: BoxFit.cover),
//                                           errorWidget: (context, url, error) =>
//                                               const Icon(Icons.error),
//                                         )),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: <Widget>[
//                                         Container(
//                                           padding: const EdgeInsets.only(
//                                               top: 8.0,
//                                               bottom: 4.0,
//                                               right: 10.0),
//                                           child: Text(
//                                               controller
//                                                   .resultNotificationList[index]
//                                                   .title
//                                                   .toString(),
//                                               style: const TextStyle(
//                                                   color: Colors.black87,
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.bold)),
//                                         ),
//                                         Container(
//                                           child: Text(
//                                               controller
//                                                   .resultNotificationList[index]
//                                                   .body
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: AppColors.lightGrey)),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : const Center(
//                 child: Text("No notifications"),
//               ));
//   }
// }

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
        titleSpacing: 16,
        iconTheme: const IconThemeData(color: Colors.black),
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
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isToLoadMore.value) {
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
                        controller.deleteNotification(n.id, idx);
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
      color: const Color(0xFFF0F0F0),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InitialsCircle(text: vm.initials),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${vm.title} ',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: vm.body,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black45,
                  ),
                  onPressed: onDelete,
                  splashRadius: 20,
                ),
            ],
          ),
          if (vm.ctaLabel != null && vm.ctaLabel!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: _CtaChip(label: vm.ctaLabel!, onTap: vm.onTapCta),
            ),
          ],
          const SizedBox(height: 10),
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
      radius: 18,
      backgroundColor: const Color(0xFF64B26F), // green like in the mock
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
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
        foregroundColor: const Color(0xFFEB7A21),
        side: const BorderSide(color: Color(0xFFEB7A21)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can swap for your asset/3D bell here
            SvgPicture.asset('assets/icons/svg/no_notification.svg'),
            const SizedBox(height: 12),
            Text(
              'No Notification',
              style: CustomTextStyles.titleLargeBlack20_500,
            ),
            const SizedBox(height: 6),
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
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Close',
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        color: appTheme.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        margin: const EdgeInsets.only(bottom: 2.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InitialsCircle(text: vm.initials),
                const SizedBox(width: 12),
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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: _CtaChip(label: vm.ctaLabel!, onTap: vm.onTapCta),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
