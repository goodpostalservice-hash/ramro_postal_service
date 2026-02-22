import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_export.dart';
import '../controller/order_history_controller.dart';
import '../model/order_history_model.dart';
import 'widgets/empty_orders.dart';
import 'widgets/order_cards.dart';
import 'widgets/order_detail_sheet.dart';

class OrderHistoryScreen extends GetView<OrderHistoryController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderHistoryController());
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.gray25,
        centerTitle: true,
        title: Text(
          "Order History",
          style: CustomTextStyles.titleLargeBlack20_500.copyWith(
            fontSize: getFontSize(20),
          ),
        ),
      ),
      body: Obx(() {
        final orders = controller.modelValue.value.orders ?? [];

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orders.isEmpty) {
          return EmptyOrdersState(
            onRefresh: () async {
              controller.getOrderHistory();
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.getOrderHistory();
          },
          child: ListView.separated(
            padding: getPadding(all: 16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: getVerticalSize(12)),
            itemBuilder: (context, index) {
              final o = orders[index];
              return OrderCard(
                order: o,
                onTap: () => _showOrderDetailsSheet(context, o),
              );
            },
          ),
        );
      }),
    );
  }

  void _showOrderDetailsSheet(BuildContext context, Orders order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: appTheme.gray50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(getHorizontalSize(20)),
        ),
      ),
      builder: (_) => OrderDetailsSheet(order: order),
    );
  }
}
