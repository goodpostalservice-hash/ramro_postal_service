import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/order_history_response.dart';
import '../controllers/orders_controller.dart';

class OrderDetailView extends GetView<OrdersController> {
  // In a real app, you might get this via arguments or controller
  final Orders order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Order #${order.orderUuid?.substring(0, 8) ?? order.id}'),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Timeline Card
            _buildDeliveryTimelineCard(theme),
            const SizedBox(height: 16),

            // 2. Driver Info Card
            _buildDriverInfoCard(theme),
            const SizedBox(height: 16),

            // 3. Payment Summary
            _buildSectionTitle(theme, 'Payment Summary'),
            _buildPaymentCard(theme),
            const SizedBox(height: 16),

            // 4. Specifications
            _buildSectionTitle(theme, 'Specifications'),
            _buildSpecsChips(theme),
            const SizedBox(height: 24),

            // 5. Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDeliveryTimelineCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Icons
          Column(
            children: [
              const Icon(
                Icons.radio_button_checked,
                color: Colors.green,
                size: 24,
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
              const Icon(Icons.location_on, color: Colors.red, size: 24),
            ],
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup Point',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Current Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Text(
                  'Destination',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  order.receiverName ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (order.receiverPhone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.receiverPhone!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard(ThemeData theme) {
    // Mocking driver data as it's not fully in the model
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
            radius: 24,
            child: Icon(Icons.person, color: theme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Driver Info', // Placeholder name
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.vechicleType ?? 'Vehicle'} • ${order.deliveryScope ?? 'Standard'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(
                  '4.8', // Mock rating
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildPriceRow('Delivery Fee', order.deliveryFee),
          const SizedBox(height: 8),
          _buildPriceRow('Tax', order.taxAmount),
          const SizedBox(height: 8),
          _buildPriceRow('Discount', '- ${order.discountAmount}'),
          const Divider(height: 24),
          _buildPriceRow(
            'Total Amount',
            order.totalAmount,
            isTotal: true,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(
                'Method: ${order.paymentMethod?.toUpperCase() ?? 'N/A'}',
                Colors.blue,
              ),
              _buildStatusChip(
                'Status: ${order.paymentStatus?.toUpperCase() ?? 'N/A'}',
                order.paymentStatus?.toLowerCase() == 'paid'
                    ? Colors.green
                    : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String? value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          '\$${value ?? '0.00'}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSpecsChips(ThemeData theme) {
    List<String> specs = [
      'Priority: ${order.orderPriority ?? 'Normal'}',
      'Fragile: ${order.fragileHandling ?? 'No'}',
      'Scope: ${order.deliveryScope?.replaceAll('_', ' ') ?? 'Local'}',
      'Payer: ${order.payeer ?? 'Sender'}',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specs.map((spec) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            spec,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Feedback logic
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Give Feedback'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Tracking logic
            },
            icon: const Icon(Icons.track_changes),
            label: const Text('Track Order'),
          ),
        ),
      ],
    );
  }
}
