import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import '../controller/home_driver_map_controller.dart';

/// Public API
Future<void> showSaveAddressDialog(
  BuildContext context, {
  required LatLng latLng,
  required String destinationAddress,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Save Address',
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, _, __) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: .98, end: 1).animate(curved),
          child: _SaveAddressDialog(
            latLng: latLng,
            destinationAddress: destinationAddress,
          ),
        ),
      );
    },
  );
}

/// Internals
class _SaveAddressDialog extends StatefulWidget {
  final LatLng latLng;
  final String destinationAddress;

  const _SaveAddressDialog({
    required this.latLng,
    required this.destinationAddress,
  });

  @override
  State<_SaveAddressDialog> createState() => _SaveAddressDialogState();
}

class _SaveAddressDialogState extends State<_SaveAddressDialog> {
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _addressTypes = const ['Home', 'Work', 'Other'];
  String? _selectedType;
  bool _isDefault = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String get _finalName {
    final custom = _nameCtrl.text.trim();
    if (custom.isNotEmpty) return custom;
    return _selectedType ?? '';
  }

  IconData _iconFor(String t) {
    switch (t) {
      case 'Home':
        return Icons.home_rounded;
      case 'Work':
        return Icons.work_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  Color _chipColor(BuildContext ctx) =>
      Theme.of(ctx).colorScheme.surfaceContainerHighest;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_finalName.isEmpty) {
      _snack('Please select a type or enter a custom name');
      return;
    }

    final driver = Get.find<HomeDriverMapController>();
    try {
      await driver.saveQR(
        widget.latLng.longitude.toString(),
        widget.latLng.latitude.toString(),
        widget.destinationAddress,
        _finalName,
        _isDefault,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      // refresh saved list
      Get.put(SavedAddressController());
      // success toast (use your own AppSnackbar if you prefer)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New location created successfully!')),
      );
    } catch (e) {
      _snack('Failed to save address');
    }
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final driver = Get.find<HomeDriverMapController>();
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(context),
                    const SizedBox(height: 16),
                    _addressTypeChips(context),
                    const SizedBox(height: 12),
                    _customNameField(context),
                    const SizedBox(height: 8),
                    _defaultSwitch(context),
                    const SizedBox(height: 16),
                    _footerButtons(driver),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.location_on_rounded, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Save Address',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                widget.destinationAddress,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
        ),
      ],
    );
  }

  Widget _addressTypeChips(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _addressTypes.map((t) {
          final selected = _selectedType == t && _nameCtrl.text.trim().isEmpty;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selectedType = t;
                // if user had typed, keep custom; chips only apply when field empty
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withOpacity(.12)
                    : _chipColor(context),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? cs.primary : cs.outlineVariant,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFor(t),
                    size: 18,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? cs.primary : cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _customNameField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: _nameCtrl,
      maxLength: 30,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Custom Name (optional)',
        hintText: 'e.g. Gym, School, Friend’s House',
        prefixIcon: const Icon(Icons.edit_rounded),
        counterText: '',
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),
      onChanged: (_) => setState(() {}),
      validator: (_) {
        // allow empty; only validate if provided
        final v = _nameCtrl.text.trim();
        if (v.isEmpty) return null;
        if (v.length < 2) return 'Too short';
        return null;
      },
    );
  }

  Widget _defaultSwitch(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Set as default address'),
        subtitle: const Text('Use this address by default'),
        value: _isDefault,
        onChanged: (v) => setState(() => _isDefault = v),
        activeColor: cs.primary,
      ),
    );
  }

  Widget _footerButtons(HomeDriverMapController driver) {
    return Obx(() {
      final isLoading = driver.isLoading.value;
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: isLoading ? null : _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.primary,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        key: ValueKey('text'),
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
