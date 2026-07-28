import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    super.key,
    this.controller,
    this.hintText = 'Enter address or smart code',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.suggestions = const <String>[],

    this.onSuggestionTap,
    this.margin = AppSpacing.pageHorizontalPadding,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final FocusNode? focusNode;

  /// Chips shown below the field (e.g., history or quick shortcuts)
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;

  /// Outer margin for the whole panel (search + chips)
  final EdgeInsets margin;

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    const outline = Colors.transparent;

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field card ONLY (chips won't inherit this background)
          GestureDetector(
            onTap: _isEnabled ? onTap : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: appTheme.white,
                borderRadius: AppRadius.cardRadius,
              ),
              child: SizedBox(
                height: AppSizes.inputHeight,
                child: AbsorbPointer(
                  absorbing: _isEnabled,
                  child: TextField(
                    controller: controller,
                    // onTap: onTap,
                    onChanged: onChanged,
                    focusNode: focusNode,
                    onSubmitted: onSubmitted,
                    readOnly: readOnly,
                    textInputAction: TextInputAction.search,
                    style: CustomTextStyles.bodyLargeGray800,
                    decoration: InputDecoration(
                      isDense: true,
                      // properly padded/search icon with aligned baseline
                      prefixIcon: Padding(
                        padding: AppSpacing.only(
                          left: AppSpacing.md + AppSpacing.xxs,
                          top: AppSpacing.md,
                          right: AppSpacing.sm + AppSpacing.xxs,
                          bottom: AppSpacing.md,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.iconsSvgSearch,
                          width: AppSizes.iconMd,
                          height: AppSizes.iconMd,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: AppSpacing.mega,
                        minHeight: AppSpacing.mega,
                      ),
                      hintText: hintText,
                      hintStyle: CustomTextStyles.bodyLargeGray800.copyWith(
                        height: 1.35,
                      ),
                      filled: true,
                      fillColor: appTheme.gray50,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.cardRadius,
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.cardRadius,
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.cardRadius,
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Spacing between search and chips
          if (suggestions.isNotEmpty) AppSpacing.gapSm,

          // Chips now sit on the page's background (not inside the card/grey box)
          if (suggestions.isNotEmpty)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: suggestions
                  .map(
                    (s) => _SuggestionChip(
                      label: s,
                      onTap: () => onSuggestionTap?.call(s),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme.white,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: appTheme.gray200, width: getSize(1.0)),
          ),
          child: Text(
            label,
            style: CustomTextStyles.bodySmallBlack12_400.copyWith(
              color: appTheme.black,
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage
class ExampleHeaderOverMap extends StatefulWidget {
  const ExampleHeaderOverMap({super.key});
  @override
  State<ExampleHeaderOverMap> createState() => _ExampleHeaderOverMapState();
}

class _ExampleHeaderOverMapState extends State<ExampleHeaderOverMap> {
  final _searchCtrl = TextEditingController();
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: SearchPanel(
          controller: _searchCtrl,
          hintText: 'Enter address or smart code',
          suggestions: const ['Civil hospital', 'Pulchowk'],
          onSuggestionTap: (text) => _searchCtrl.text = text,
          onSubmitted: (query) {},
          margin: AppSpacing.only(
            left: AppSpacing.md,
            top: AppSpacing.sm,
            right: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}
