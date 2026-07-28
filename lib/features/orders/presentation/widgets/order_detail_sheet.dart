import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../data/models/order_history_response.dart';
import 'order_helper.dart';
import 'pill_chip.dart';

class OrderDetailsSheet extends StatelessWidget {
  const OrderDetailsSheet({super.key, required this.order});

  final Orders order;

  @override
  Widget build(BuildContext context) {
    final status = (order.status ?? 'Unknown').trim();
    final payStatus = (order.paymentStatus ?? 'Unknown').trim();

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
            _sheetHeader(status, payStatus),
            SizedBox(height: getVerticalSize(14)),
            _SectionCard(
              title: 'Receiver',
              rows: [
                _KV('Name', order.receiverName),
                _KV('Phone', order.receiverPhone),
                _KV('Receiver Coordinates', order.receiverCoordinates),
              ],
            ),
            SizedBox(height: getVerticalSize(12)),
            _SectionCard(
              title: 'Payment',
              rows: [
                _KV('Method', order.paymentMethod),
                _KV('Total', money(order.totalAmount)),
                _KV('Delivery Fee', money(order.deliveryFee)),
                _KV('Discount', money(order.discountAmount)),
                _KV('Tax', money(order.taxAmount)),
              ],
            ),
            SizedBox(height: getVerticalSize(12)),
            _SectionCard(
              title: 'Delivery Info',
              rows: [
                _KV('Delivery Type', order.deliveryType),
                _KV('Delivery Scope', order.deliveryScope),
                _KV('Vehicle Type', order.vechicleType),
                _KV('Priority', order.orderPriority),
                _KV('Fragile', order.fragileHandling),
              ],
            ),
            SizedBox(height: getVerticalSize(14)),
            AppButton(
              label: 'Close',
              onPressed: Get.back,
              borderRadius: getHorizontalSize(12),
              icon: const Icon(Icons.done_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetHeader(String status, String payStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.trackingNumber?.isNotEmpty == true
              ? 'Tracking: ${order.trackingNumber}'
              : 'Order Details',
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
              text: 'Payment: $payStatus',
              type: pillTypeFromPayment(payStatus),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// Section Card with key/value rows + dividers
// ============================================================
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.rows});

  final String title;
  final List<_KV> rows; // <-- Explicitly expect a list of _KV data objects

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
          // Map the _KV data objects into _KVRow widgets
          ...List.generate(rows.length, (i) {
            return Column(
              children: [
                _KVRow(rows[i]), // <-- Wrap the data object in the widget here
                if (i != rows.length - 1)
                  Padding(
                    padding: getPadding(top: 10, bottom: 10),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: appTheme.gray100,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// Data class for Key-Value pairs
class _KV {
  const _KV(this.key, this.value);
  final String key;
  final String? value;
}

// Widget that renders the _KV data
class _KVRow extends StatelessWidget {
  const _KVRow(this.kv);
  final _KV kv;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: getHorizontalSize(130),
          child: Text(
            kv.key,
            style: CustomTextStyles.bodyMediumBlack1000_14_500.copyWith(
              color: appTheme.gray800,
              fontSize: getFontSize(14),
            ),
          ),
        ),
        Expanded(
          child: Text(
            (kv.value != null && kv.value!.trim().isNotEmpty)
                ? kv.value!
                : '—',
            style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
              color: appTheme.gray700,
              fontSize: getFontSize(14),
            ),
          ),
        ),
      ],
    );
  }
}