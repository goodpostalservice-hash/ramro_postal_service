import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/design_system/theme/app_theme.dart';

import '../../../../core/widgets/custom_app_widget.dart';
import '../controllers/order_history_controller.dart';
import '../widgets/order_cards.dart';

class OrderHistoryScreen extends GetView<OrderHistoryController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: backAppBar("Order History", context),

      body: SafeArea(
        child: Obx(() {
          final orders = controller.modelValue.value.orders ?? const [];
          final errorMessage = controller.errorMessage.value;

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (errorMessage?.trim().isNotEmpty == true) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unable to load orders',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.getOrderHistory,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your order history will appear here once you start shipping.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: controller.getOrderHistory,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.getOrderHistory,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  onTap: () => Get.toNamed('/order-details', arguments: order),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
