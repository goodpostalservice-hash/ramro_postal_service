import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/features/address/data/models/save_address_request.dart';

import '../../../address/presentation/controllers/address_controller.dart';
import 'saved_address_widget.dart';

Future<void> showSaveAddressDialog(
  BuildContext context,
  String? address,
  String? coordinates,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) =>
        SaveAddressDialog(address: address, coordinates: coordinates),
  );
}

class SaveAddressDialog extends StatefulWidget {
  const SaveAddressDialog({super.key, this.address, this.coordinates});
  final String? address;
  final String? coordinates;

  @override
  State<SaveAddressDialog> createState() => _SaveAddressDialogState();
}

class _SaveAddressDialogState extends State<SaveAddressDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _coordinatesController;
  late final TextEditingController _addressController;
  final _labelController = TextEditingController();

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String _selectedLabel = '';

  final List<AddressLabelOption> _labelOptions = const [
    AddressLabelOption(label: 'Home', icon: Icons.home_rounded),
    AddressLabelOption(label: 'Work', icon: Icons.work_rounded),
    AddressLabelOption(label: 'Other', icon: Icons.location_on_rounded),
  ];
  final controller = Get.find<AddressController>();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address ?? "");
    _coordinatesController = TextEditingController(
      text: widget.coordinates ?? "",
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _coordinatesController.dispose();
    _addressController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    HapticFeedback.lightImpact();

    final request = SaveAddressRequest(
      coordinates: _coordinatesController.text,
      address: _addressController.text,
      label: _selectedLabel == 'Other' ? _labelController.text : _selectedLabel,
    );
    final success = await controller.saveAddress(request);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  void _onLabelChanged(String label) {
    setState(() => _selectedLabel = label);

    if (label == 'Other') {
      _labelController.clear();
    } else {
      _labelController.text = label;
    }

    HapticFeedback.selectionClick();
  }

  String? _requiredValidator(String? value, String fieldName) {
    final trimmedValue = value?.trim() ?? '';

    if (trimmedValue.isEmpty) {
      return '$fieldName is required';
    }

    if (trimmedValue.length > 255) {
      return '$fieldName is too long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.86,
            ),
            decoration: BoxDecoration(
              color: RamroAddressColors.background(context),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  title: 'Save Address',
                  onClose: () => Navigator.pop(context),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RamroSectionLabel('LOCATION DETAILS'),

                          const SizedBox(height: 14),

                          RamroAddressTextField(
                            controller: _coordinatesController,
                            label: 'Coordinates',
                            hint: '27.7172° N, 85.3240° E',
                            icon: Icons.my_location_rounded,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              return _requiredValidator(value, 'Coordinates');
                            },
                          ),

                          const SizedBox(height: 14),

                          RamroAddressTextField(
                            controller: _addressController,
                            label: 'Address',
                            hint: 'Street, City, Country',
                            icon: Icons.location_on_rounded,
                            maxLines: 2,
                            validator: (value) {
                              return _requiredValidator(value, 'Address');
                            },
                          ),

                          const SizedBox(height: 26),

                          const RamroSectionLabel('LABEL'),

                          const SizedBox(height: 14),

                          FormField<String>(
                            initialValue: _selectedLabel,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a label';
                              }
                              return null;
                            },
                            builder: (field) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RamroLabelSelector(
                                  options: _labelOptions,
                                  selectedLabel: _selectedLabel,
                                  onChanged: (label) {
                                    field.didChange(label);
                                    _onLabelChanged(label);
                                  },
                                ),
                                if (field.hasError) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
                                      field.errorText!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: RamroAddressColors.error(
                                              context,
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (_selectedLabel == 'Other') ...[
                            const SizedBox(height: 14),
                            RamroAddressTextField(
                              controller: _labelController,
                              label: 'Custom Label',
                              hint: 'e.g. Gym, School',
                              icon: Icons.label_rounded,
                              validator: (value) {
                                return _requiredValidator(value, 'Label');
                              },
                            ),
                          ],

                          const SizedBox(height: 28),

                          Obx(() {
                            final controller = Get.find<AddressController>();

                            return RamroSaveAddressButton(
                              isLoading: controller.isSaving.value,
                              onPressed: _handleSave,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _DialogHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final textColor = RamroAddressColors.textPrimary(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 14, 12),
      decoration: BoxDecoration(
        color: RamroAddressColors.card(context),
        border: Border(
          bottom: BorderSide(
            color: RamroAddressColors.border(context),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: -0.2,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: textColor),
            style: IconButton.styleFrom(
              backgroundColor: RamroAddressColors.background(context),
              minimumSize: const Size(38, 38),
              fixedSize: const Size(38, 38),
            ),
          ),
        ],
      ),
    );
  }
}
