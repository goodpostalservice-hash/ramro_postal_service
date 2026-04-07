import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

Future<MapType?> showMapSettingsSheet(
  BuildContext context, {
  MapType initial = MapType.normal,
  required String standardThumb,
  required String satelliteThumb,
  required String hybridThumb,
}) {
  return showModalBottomSheet<MapType>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent, // we’ll draw our own rounded sheet
    barrierColor: Colors.black54,
    builder: (ctx) {
      return _FloatingSheet(
        child: _MapSettingsContent(
          initial: initial,
          standardThumb: standardThumb,
          satelliteThumb: satelliteThumb,
          hybridThumb: hybridThumb,
        ),
      );
    },
  );
}

class _FloatingSheet extends StatelessWidget {
  const _FloatingSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, bottom + 12),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class _MapSettingsContent extends StatefulWidget {
  const _MapSettingsContent({
    required this.initial,
    required this.standardThumb,
    required this.satelliteThumb,
    required this.hybridThumb,
  });

  final MapType initial;
  final String? standardThumb;
  final String? satelliteThumb;
  final String? hybridThumb;

  @override
  State<_MapSettingsContent> createState() => _MapSettingsContentState();
}

class _MapSettingsContentState extends State<_MapSettingsContent> {
  late MapType _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
          child: Row(
            children: [
              Text(
                'Map settings',
                style: CustomTextStyles.headlineSmall_24_500,
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Body
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Map types', style: CustomTextStyles.titleMediumBlack18_500),
              const SizedBox(height: 12),

              // Three tiles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TypeTile(
                    label: 'Standard',
                    svgAsset: widget.standardThumb,
                    selected: _selected == MapType.normal,
                    onTap: () => setState(() => _selected = MapType.normal),
                    accent: appTheme.orangeBase,
                  ),
                  _TypeTile(
                    label: 'Satellite',
                    svgAsset: widget.satelliteThumb,
                    selected: _selected == MapType.satellite,
                    onTap: () => setState(() => _selected = MapType.satellite),
                    accent: appTheme.orangeBase,
                  ),
                  _TypeTile(
                    label: 'Hybrid',
                    svgAsset: widget.hybridThumb,
                    selected: _selected == MapType.hybrid,
                    onTap: () => setState(() => _selected = MapType.hybrid),
                    accent: appTheme.orangeBase,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Save button (appTheme.orangeBase pill with slight inner shadow look)
              SizedBox(
                width: double.infinity,
                child: _GradientButton(
                  text: 'Save',
                  onPressed: () => Navigator.pop<MapType>(context, _selected),
                  color: appTheme.orangeBase,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.label,
    required this.svgAsset,
    required this.selected,
    required this.onTap,
    required this.accent,
  });

  final String label;
  final String? svgAsset;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? accent : Colors.transparent;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: SvgPicture.asset(svgAsset!, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: selected
                ? CustomTextStyles.bodyMediumBlack14_400.copyWith(
                    color: appTheme.orange300,
                  )
                : CustomTextStyles.bodyMediumBlack14_400.copyWith(
                    color: appTheme.gray900,
                  ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    required this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSize(43.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // simple vertical gradient to match the soft appTheme.orangeBase pill
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text('Save', style: CustomTextStyles.bodyLargeGray_16_500),
        ),
      ),
    );
  }
}
