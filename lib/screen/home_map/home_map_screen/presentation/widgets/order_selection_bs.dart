import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/core/values/s_spacing.dart';

class OrderSelectionBottomSheet extends StatelessWidget {
  const OrderSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      // enableDrag: false,
      // isScrollControlled: true,
      builder: (_) => const OrderSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const hasSenderLoc = true;
    const hasReceiverLoc = false;
    const estimatedPrice = "450.00";

    return Container(
      padding: SSpacing.lgMargin, // Using lgMargin (all)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Details', style: theme.textTheme.titleLarge),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SSpacing.mdH, // Correct usage of utility SizedBox
          // Location Selection Section
          _LocationSelector(
            label: 'Pickup Location',
            isSet: hasSenderLoc,
            theme: theme,
          ),
          SSpacing.xsH,
          _LocationSelector(
            label: 'Delivery Location',
            isSet: hasReceiverLoc,
            theme: theme,
          ),
          SSpacing.lgH,

          // Vehicle Type Selection
          Text('Vehicle Type', style: theme.textTheme.labelLarge),
          SSpacing.xsH,
          Row(
            children: [
              Expanded(
                child: _SelectableBox(
                  label: 'Bike',
                  icon: Icons.directions_bike,
                  isSelected: true,
                  theme: theme,
                ),
              ),
              SSpacing.mdW,
              Expanded(
                child: _SelectableBox(
                  label: 'Car',
                  icon: Icons.directions_car,
                  isSelected: false,
                  theme: theme,
                ),
              ),
            ],
          ),
          SSpacing.lgH,

          // Delivery Scope Selection
          Text('Delivery Scope', style: theme.textTheme.labelLarge),
          SSpacing.xsH,
          Row(
            children: [
              Expanded(
                child: _SelectableBox(
                  label: 'Inside City',
                  icon: Icons.location_city,
                  isSelected: true,
                  theme: theme,
                ),
              ),
              SSpacing.mdW,
              Expanded(
                child: _SelectableBox(
                  label: 'Outside City',
                  icon: Icons.map,
                  isSelected: false,
                  theme: theme,
                ),
              ),
            ],
          ),
          SSpacing.xlH,

          // ESTIMATED PRICE SECTION
          Divider(color: theme.colorScheme.outlineVariant),
          Padding(
            padding: SSpacing.mdMarginH, // Using symmetric vertical margin
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimated Total:', style: theme.textTheme.titleMedium),
                Text(
                  'Rs. $estimatedPrice',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Confirm Selection'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  final String label;
  final bool isSet;
  final ThemeData theme;

  const _LocationSelector({
    required this.label,
    required this.isSet,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: SSpacing.mdMargin,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8), // Assuming a standard radius
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
            Text(
              isSet ? '$label Set' : 'Pick $label from Map',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isSet
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.secondary,
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

  const _SelectableBox({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: SSpacing.mdMarginH,
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
