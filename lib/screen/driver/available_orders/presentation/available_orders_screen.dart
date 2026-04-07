import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/app/core/utils/utils.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/widgets/custom_app_widget.dart';

import '../../../../app/routes/app_pages.dart';
import '../model/available_orders_model.dart';

// ─── Sample Data ────────────────────────────────────────────────────────────
final List<AvailableOrderModel> sampleOrders = [
  AvailableOrderModel(
    id: 1,
    orderUuid: 'ORD-698C7E96F4231',
    userId: 1,
    receiverName: 'Test',
    receiverPhone: '9898',
    totalAmount: '40.00',
    payeer: 'sender',
    senderLongitude: '85.2980',
    senderLatitude: '27.6850',
    senderCoordinates: '27.6850,85.2980',
    receiverLongitude: '27.7007',
    receiverLatitude: '85.3120',
    receiverCoordinates: '27.7007,85.3120',
    paymentMethod: 'cash',
    paymentStatus: 'pending',
    deliveryType: 'standard',
    deliveryScope: 'inside_city',
    orderPriority: 'normal',
    fragileHandling: 'no',
    vehicleType: 'bike',
    trackingNumber: 'TRK-698C7E96F4234',
    discountAmount: '0.00',
    taxAmount: '0.00',
    deliveryFee: '0.00',
    status: 'pending',
    createdAt: DateTime.parse('2026-02-11T13:05:27.000000Z'),
    updatedAt: DateTime.parse('2026-02-11T13:05:27.000000Z'),
  ),
  AvailableOrderModel(
    id: 2,
    orderUuid: 'ORD-69933CB45FAF3',
    userId: 1,
    receiverName: 'Test',
    receiverPhone: '9898',
    totalAmount: '40.00',
    payeer: 'sender',
    senderLongitude: '85.2980',
    senderLatitude: '27.6850',
    senderCoordinates: '27.6850,85.2980',
    receiverLongitude: '27.7007',
    receiverLatitude: '85.3120',
    receiverCoordinates: '27.7007,85.3120',
    paymentMethod: 'cash',
    paymentStatus: 'pending',
    deliveryType: 'standard',
    deliveryScope: 'inside_city',
    orderPriority: 'normal',
    fragileHandling: 'no',
    vehicleType: 'bike',
    trackingNumber: 'TRK-69933CB45FAF6',
    discountAmount: '0.00',
    taxAmount: '0.00',
    deliveryFee: '0.00',
    status: 'pending',
    createdAt: DateTime.parse('2026-02-16T15:50:12.000000Z'),
    updatedAt: DateTime.parse('2026-02-16T15:50:12.000000Z'),
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class AvailableOrdersScreen extends StatelessWidget {
  const AvailableOrdersScreen({super.key});

  static const Color _success = Color(0xFF34C759);
  static const Color _success2 = Color(0xFF30D158);
  static const Color _danger = Color(0xFFFF3B30);
  static const Color _warning = Color(0xFFFF9500);
  static const Color _info = Color(0xFF007AFF);

  @override
  Widget build(BuildContext context) {
    // ensures your saved responsive system is initialized if your project uses it
    // ignore: unused_local_variable
    final mediaQueryData = MediaQuery.of(context);

    final pendingCount = sampleOrders
        .where((o) => (o.status).toLowerCase() == 'pending')
        .length;
    final bikeCount = sampleOrders
        .where((o) => (o.vehicleType).toLowerCase() == 'bike')
        .length;
    final cashCount = sampleOrders
        .where((o) => (o.paymentMethod).toLowerCase() == 'cash')
        .length;

    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: backAppBar("Available Orders", context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getHorizontalSize(20),
                right: getHorizontalSize(20),
                top: getVerticalSize(16),
              ),
              child: Row(
                children: [
                  _StatChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Pending',
                    value: '$pendingCount',
                    color: _warning,
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  _StatChip(
                    icon: Icons.two_wheeler_rounded,
                    label: 'Bike',
                    value: '$bikeCount',
                    color: _success,
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  _StatChip(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Cash',
                    value: '$cashCount',
                    color: _info,
                  ),
                ],
              ),
            ),
            SizedBox(height: getVerticalSize(8)),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    getHorizontalSize(16),
                    getVerticalSize(8),
                    getHorizontalSize(16),
                    getVerticalSize(24),
                  ),
                  itemCount: sampleOrders.length,
                  itemBuilder: (context, index) {
                    final order = sampleOrders[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 520),
                      child: SlideAnimation(
                        verticalOffset: 40,
                        curve: Curves.easeOutCubic,
                        child: FadeInAnimation(
                          child: _OrderCard(
                            order: order,
                            headerBlack: appTheme.black,
                            success: _success,
                            success2: _success2,
                            danger: _danger,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTapNotification;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onTapNotification,
  });

  static const Color _headerBlack = Color(0xFF0F0F0F);
  static const Color _textMuted = Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        getHorizontalSize(20),
        getVerticalSize(20),
        getHorizontalSize(20),
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: getFontSize(26),
                  fontWeight: FontWeight.w800,
                  color: _headerBlack,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: getVerticalSize(2)),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: getFontSize(13),
                  color: _textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(getHorizontalSize(14)),
            onTap: onTapNotification,
            child: Container(
              width: getSize(44),
              height: getSize(44),
              decoration: BoxDecoration(
                color: _headerBlack,
                borderRadius: BorderRadius.circular(getHorizontalSize(14)),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getVerticalSize(10),
          horizontal: getHorizontalSize(12),
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(getHorizontalSize(14)),
          border: Border.all(color: color.withOpacity(0.15), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: getHorizontalSize(6)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: getFontSize(15),
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: getFontSize(10),
                    color: color.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────
class _OrderCard extends StatefulWidget {
  final AvailableOrderModel order;
  final Color headerBlack;
  final Color success;
  final Color success2;
  final Color danger;

  const _OrderCard({
    required this.order,
    required this.headerBlack,
    required this.success,
    required this.success2,
    required this.danger,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;

    return GestureDetector(
      onTapDown: (_) => _pressController.reverse(),
      onTapUp: (_) {
        _pressController.forward();

        SUtils.logPrint('${o.status}');

        Get.toNamed(Routes.ORDER_DETAIL, arguments: o.id);
      },
      onTapCancel: () => _pressController.forward(),
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (_, child) =>
            Transform.scale(scale: _pressController.value, child: child),
        child: Container(
          margin: EdgeInsets.only(bottom: getVerticalSize(14)),
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.circular(getHorizontalSize(22)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(16),
                  getVerticalSize(16),
                  getHorizontalSize(16),
                  0,
                ),
                child: Text(
                  _formatDate(o.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appTheme.black.withOpacity(0.5),
                    fontSize: getFontSize(11),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // ── Route section ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(16),
                  getVerticalSize(16),
                  getHorizontalSize(16),
                  0,
                ),
                child: Row(
                  children: [
                    const _RouteTimeline(),
                    SizedBox(width: getHorizontalSize(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RoutePoint(
                            label: 'PICKUP',
                            coords: (o.senderCoordinates).toString(),
                            color: widget.success,
                          ),
                          SizedBox(height: getVerticalSize(18)),
                          _RoutePoint(
                            label: 'DELIVERY',
                            coords: (o.receiverCoordinates).toString(),
                            color: widget.danger,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: getVerticalSize(16)),
              Divider(
                height: 1,
                color: const Color(0xFFF0F0F0),
                indent: getHorizontalSize(16),
                endIndent: getHorizontalSize(16),
              ),

              // ── Info chips ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(16),
                  getVerticalSize(12),
                  getHorizontalSize(16),
                  0,
                ),
                child: Row(
                  children: [
                    _InfoChip(
                      icon: Icons.person_outline_rounded,
                      text: (o.receiverName ?? '').toString(),
                    ),
                    SizedBox(width: getHorizontalSize(8)),
                    _InfoChip(
                      icon: Icons.account_balance_wallet_outlined,
                      text: (o.paymentMethod ?? '').toString().toUpperCase(),
                    ),
                    SizedBox(width: getHorizontalSize(8)),
                    _InfoChip(
                      icon: Icons.location_city_rounded,
                      text: (o.deliveryScope ?? '').toString().replaceAll(
                        '_',
                        ' ',
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: getVerticalSize(14)),

              // ── Footer: amount + accept button ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                  getHorizontalSize(16),
                  0,
                  getHorizontalSize(16),
                  getVerticalSize(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: getFontSize(11),
                            color: const Color(0xFFAAAAAA),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Rs. ${(o.totalAmount)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: getFontSize(22),
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F0F0F),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    _AcceptButton(
                      success: widget.success,
                      success2: widget.success2,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Accepted order ${(o.trackingNumber ?? '')}',
                            ),
                            backgroundColor: widget.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Accept Button ───────────────────────────────────────────────────────────
class _AcceptButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color success;
  final Color success2;

  const _AcceptButton({
    required this.onTap,
    required this.success,
    required this.success2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(getHorizontalSize(16)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getHorizontalSize(24),
          vertical: getVerticalSize(13),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [success, success2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(getHorizontalSize(16)),
          boxShadow: [
            BoxShadow(
              color: success.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: getHorizontalSize(6)),
            Text(
              'Accept Order',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: getFontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Route Timeline ──────────────────────────────────────────────────────────
class _RouteTimeline extends StatelessWidget {
  const _RouteTimeline();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getHorizontalSize(20),
      height: getVerticalSize(68),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: getVerticalSize(14),
            bottom: getVerticalSize(14),
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: const _DashedLinePainter(),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: getSize(12),
              height: getSize(12),
              decoration: const BoxDecoration(
                color: Color(0xFF34C759),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: getSize(12),
              height: getSize(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;
    final paint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 2;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Route Point ─────────────────────────────────────────────────────────────
class _RoutePoint extends StatelessWidget {
  final String label;
  final String coords;
  final Color color;

  const _RoutePoint({
    required this.label,
    required this.coords,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: getFontSize(10),
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: getVerticalSize(2)),
        Text(
          coords,
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: getFontSize(14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF222222),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getHorizontalSize(10),
        vertical: getVerticalSize(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4),
        borderRadius: BorderRadius.circular(getHorizontalSize(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF666666)),
          SizedBox(width: getHorizontalSize(5)),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: getFontSize(11),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}
