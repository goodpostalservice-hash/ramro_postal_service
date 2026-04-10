import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/core/values/s_spacing.dart';
import '../../../../../app/data/params/estimate_cost_param.dart';
import '../../../../../app/data/params/place_order_param.dart';
import '../controller/place_order_controller.dart';

class OrderSelectionBottomSheet extends StatefulWidget {
  final String senderLat;
  final String senderLng;
  final String receiverLat;
  final String receiverLng;

  const OrderSelectionBottomSheet({
    super.key,
    required this.senderLat,
    required this.senderLng,
    required this.receiverLat,
    required this.receiverLng,
  });

  static void show(
    BuildContext context, {
    required String sLat,
    required String sLng,
    required String rLat,
    required String rLng,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (_) => OrderSelectionBottomSheet(
        senderLat: sLat,
        senderLng: sLng,
        receiverLat: rLat,
        receiverLng: rLng,
      ),
    );
  }

  @override
  State<OrderSelectionBottomSheet> createState() =>
      _OrderSelectionBottomSheetState();
}

class _OrderSelectionBottomSheetState extends State<OrderSelectionBottomSheet> {
  final controller = Get.put<PlaceOrderController>(PlaceOrderController());

  // Local state for selections
  final RxString selectedVehicle = 'bike'.obs;
  final RxString selectedScope = 'inside_city'.obs;

  @override
  void initState() {
    super.initState();
    _fetchEstimate();
  }

  void _fetchEstimate() {
    controller.getEstimateCost(
      param: EstimateCostParam(
        senderLatitude: widget.senderLat,
        senderLongitude: widget.senderLng,
        receiverLatitude: widget.receiverLat,
        receiverLongitude: widget.receiverLng,
        vehicleType: 'bike',
        deliveryScope: 'inside_city',
      ),
    );
  }

  void _handlePlaceOrder() {
    final estimate = controller.estimateCostResult.value.data;
    if (estimate == null) return;

    controller.placeOrder(
      param: PlaceOrderParam(
        userId: "1",
        receiverName: "Receiver Name",
        receiverPhone: "9800000000",
        payeer: "sender",
        senderLatitude: widget.senderLat,
        senderLongitude: widget.senderLng,
        senderCoordinates: "${widget.senderLat},${widget.senderLng}",
        receiverLatitude: widget.receiverLat,
        receiverLongitude: widget.receiverLng,
        receiverCoordinates: "${widget.receiverLat},${widget.receiverLng}",
        paymentMethod: "cash",
        totalAmount: estimate.estimatedCost.toString(),
        deliveryScope: selectedScope.value,
        vehicleType: selectedVehicle.value,
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: SSpacing.lgMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Details', style: theme.textTheme.titleLarge),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SSpacing.mdH,
          _LocationSelector(label: 'Pickup', isSet: true, theme: theme),
          SSpacing.xsH,
          _LocationSelector(label: 'Delivery', isSet: true, theme: theme),
          SSpacing.lgH,

          // Vehicle Type
          Text('Vehicle Type', style: theme.textTheme.labelLarge),
          SSpacing.xsH,
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _SelectableBox(
                    label: 'Bike',
                    icon: Icons.directions_bike,
                    isSelected: selectedVehicle.value == 'bike',
                    theme: theme,
                    onTap: () {
                      selectedVehicle.value = 'bike';
                      _fetchEstimate();
                    },
                  ),
                ),
                SSpacing.mdW,
                Expanded(
                  child: _SelectableBox(
                    label: 'Car',
                    icon: Icons.directions_car,
                    isSelected: selectedVehicle.value == 'car',
                    theme: theme,
                    onTap: () {
                      selectedVehicle.value = 'car';
                      _fetchEstimate();
                    },
                  ),
                ),
              ],
            ),
          ),
          SSpacing.lgH,

          // Delivery Scope
          Text('Delivery Scope', style: theme.textTheme.labelLarge),
          SSpacing.xsH,
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _SelectableBox(
                    label: 'Inside City',
                    icon: Icons.location_city,
                    isSelected: selectedScope.value == 'inside_city',
                    theme: theme,
                    onTap: () {
                      selectedScope.value = 'inside_city';
                      _fetchEstimate();
                    },
                  ),
                ),
                SSpacing.mdW,
                Expanded(
                  child: _SelectableBox(
                    label: 'Outside City',
                    icon: Icons.map,
                    isSelected: selectedScope.value == 'outside_city',
                    theme: theme,
                    onTap: () {
                      selectedScope.value = 'outside_city';
                      _fetchEstimate();
                    },
                  ),
                ),
              ],
            ),
          ),
          SSpacing.xlH,

          // Price Section
          Divider(color: theme.colorScheme.outlineVariant),
          Obx(() {
            final result = controller.estimateCostResult.value;
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: SSpacing.mdMarginH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Total:', style: theme.textTheme.titleMedium),
                  Text(
                    'Rs. ${result.data?.estimatedCost ?? "0.00"}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          SSpacing.lgH,

          // Place Order Button
          Obx(() {
            final isPlacing = controller.placeOrderResult.value.isLoading;
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isPlacing ? null : _handlePlaceOrder,
                child: isPlacing
                    ? const CircularProgressIndicator()
                    : const Text('Confirm & Place Order'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  final String label;
  final bool isSet;
  final ThemeData theme;
  final VoidCallback? onTap; // Added onTap

  const _LocationSelector({
    required this.label,
    required this.isSet,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: SSpacing.mdMargin,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSet ? Icons.check_circle : Icons.add_location_alt,
              color: isSet
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
            ),
            SSpacing.mdW,
            Expanded(
              // Added Expanded to prevent overflow
              child: Text(
                isSet ? '$label Set' : 'Pick $label from Map',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSet
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap; // Added required onTap

  const _SelectableBox({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: SSpacing.mdMargin,
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : null,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            SSpacing.xsH,
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
