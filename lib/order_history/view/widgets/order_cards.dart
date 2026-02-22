import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/order_history/model/order_history_model.dart';

import 'order_helper.dart';
import 'pill_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final Orders order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = (order.status ?? "Unknown").trim();
    final payStatus = (order.paymentStatus ?? "Unknown").trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadiusStyle.roundedBorder16,
      child: Container(
        padding: getPadding(all: 14),
        decoration: AppDecoration.outlineGray.copyWith(
          color: appTheme.white,
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pills row
            Row(
              children: [
                Pill(
                  text: status.isEmpty ? "—" : status,
                  type: pillTypeFromStatus(status),
                ),
                SizedBox(width: getHorizontalSize(8)),
                Pill(
                  text: "Pay: ${payStatus.isEmpty ? "—" : payStatus}",
                  type: pillTypeFromPayment(payStatus),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: appTheme.gray500),
              ],
            ),

            SizedBox(height: getVerticalSize(10)),

            // Tracking
            Text(
              order.trackingNumber?.isNotEmpty == true
                  ? "Tracking: ${order.trackingNumber}"
                  : "Tracking: —",
              style: CustomTextStyles.titleLargeBlack20_500.copyWith(
                fontSize: getFontSize(16),
              ),
            ),

            SizedBox(height: getVerticalSize(8)),

            // Receiver row
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: getSize(18),
                  color: appTheme.gray700,
                ),
                SizedBox(width: getHorizontalSize(6)),
                Expanded(
                  child: Text(
                    order.receiverName?.isNotEmpty == true
                        ? order.receiverName!
                        : "Receiver —",
                    style: CustomTextStyles.bodyMediumGray14_400.copyWith(
                      color: appTheme.gray800,
                      fontSize: getFontSize(14),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: getHorizontalSize(12)),
                Icon(
                  Icons.phone_outlined,
                  size: getSize(18),
                  color: appTheme.gray700,
                ),
                SizedBox(width: getHorizontalSize(6)),
                Text(
                  order.receiverPhone?.isNotEmpty == true
                      ? order.receiverPhone!
                      : "—",
                  style: CustomTextStyles.bodyMediumGray600.copyWith(
                    color: appTheme.gray800,
                    fontSize: getFontSize(14),
                  ),
                ),
              ],
            ),

            SizedBox(height: getVerticalSize(12)),

            // Meta row
            Row(
              children: [
                MetaChip(
                  icon: Icons.payments_outlined,
                  title: "Total",
                  value: money(order.totalAmount),
                ),
                SizedBox(width: getHorizontalSize(10)),
                MetaChip(
                  icon: Icons.local_shipping_outlined,
                  title: "Delivery",
                  value: order.deliveryType ?? "—",
                ),
                const Spacer(),
                Text(
                  formatDate(order.createdAt),
                  style: CustomTextStyles.bodySmallGray12_400.copyWith(
                    color: appTheme.gray500,
                    fontSize: getFontSize(12),
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
