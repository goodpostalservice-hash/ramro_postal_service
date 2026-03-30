import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/driver/order_history/model/order_history_model.dart';

import 'order_helper.dart';
import 'pill_chip.dart';

class OrderDetailsSheet extends StatelessWidget {
  const OrderDetailsSheet({super.key, required this.order});

  final Orders order;

  @override
  Widget build(BuildContext context) {
    final status = (order.status ?? "Unknown").trim();
    final payStatus = (order.paymentStatus ?? "Unknown").trim();

    return Padding(
      padding: EdgeInsets.only(
        left: getHorizontalSize(16),
        right: getHorizontalSize(16),
        top: getVerticalSize(10),
        bottom: MediaQuery.of(context).viewInsets.bottom + getVerticalSize(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.trackingNumber?.isNotEmpty == true
                  ? "Tracking: ${order.trackingNumber}"
                  : "Order Details",
              style: CustomTextStyles.titleLargeBlack20_500.copyWith(
                fontSize: getFontSize(20),
              ),
            ),
            SizedBox(height: getVerticalSize(10)),

            Row(
              children: [
                Pill(text: status, type: pillTypeFromStatus(status)),
                SizedBox(width: getHorizontalSize(8)),
                Pill(
                  text: "Payment: $payStatus",
                  type: pillTypeFromPayment(payStatus),
                ),
              ],
            ),

            SizedBox(height: getVerticalSize(14)),

            _SectionCard(
              title: "Receiver",
              child: Column(
                children: [
                  _kv("Name", order.receiverName),
                  _kv("Phone", order.receiverPhone),
                  _kv("Receiver Coordinates", order.receiverCoordinates),
                ],
              ),
            ),

            SizedBox(height: getVerticalSize(12)),

            _SectionCard(
              title: "Payment",
              child: Column(
                children: [
                  _kv("Method", order.paymentMethod),
                  _kv("Total", money(order.totalAmount)),
                  _kv("Delivery Fee", money(order.deliveryFee)),
                  _kv("Discount", money(order.discountAmount)),
                  _kv("Tax", money(order.taxAmount)),
                ],
              ),
            ),

            SizedBox(height: getVerticalSize(12)),

            _SectionCard(
              title: "Delivery Info",
              child: Column(
                children: [
                  _kv("Delivery Type", order.deliveryType),
                  _kv("Delivery Scope", order.deliveryScope),
                  _kv("Vehicle Type", order.vechicleType),
                  _kv("Priority", order.orderPriority),
                  _kv("Fragile", order.fragileHandling),
                ],
              ),
            ),

            SizedBox(height: getVerticalSize(14)),

            // Close button using saved AppButton + styles
            AppButton(
              label: "Close",
              onPressed: () => Get.back(),
              borderRadius: getHorizontalSize(12),
              icon: const Icon(Icons.done_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String? v) {
    return Padding(
      padding: getPadding(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getHorizontalSize(130),
            child: Text(
              k,
              style: CustomTextStyles.bodyMediumBlack1000_14_500.copyWith(
                color: appTheme.gray800,
                fontSize: getFontSize(14),
              ),
            ),
          ),
          Expanded(
            child: Text(
              (v != null && v.trim().isNotEmpty) ? v : "—",
              style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                color: appTheme.gray700,
                fontSize: getFontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(all: 14),
      decoration: AppDecoration.outlineGray.copyWith(
        color: appTheme.white,
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles.titleMediumBlack18_500.copyWith(
              fontSize: getFontSize(16),
            ),
          ),
          SizedBox(height: getVerticalSize(12)),
          child,
        ],
      ),
    );
  }
}
