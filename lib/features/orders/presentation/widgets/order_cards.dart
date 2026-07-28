import 'package:flutter/material.dart';
import '../../data/models/order_history_response.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final Orders order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Icons
              _buildTimelineIcons(),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPickupDestination(),
                    const SizedBox(height: 12),
                    _buildMetaRow(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineIcons() {
    return Column(
      children: [
        const Icon(Icons.radio_button_checked, color: Colors.green, size: 20),
        Container(
          width: 2,
          height: 24,
          color: Colors.grey.shade300,
        ),
        const Icon(Icons.location_on, color: Colors.red, size: 20),
      ],
    );
  }

  Widget _buildPickupDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Location', // Model doesn't have sender address text, using placeholder
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          'Current Location', // Placeholder
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Text(
          'Destination',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          order.receiverName ?? 'Unknown', // Using receiver name as destination identifier
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            (order.status ?? 'Pending').toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(order.status),
            ),
          ),
        ),
        const Spacer(),
        // Vehicle Type
        if (order.vechicleType != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              order.vechicleType!,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        // Total Amount
        Text(
          '\$${order.totalAmount ?? '0.00'}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}