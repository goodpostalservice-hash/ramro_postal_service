import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

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
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;

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
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: getSize(52.0), // comfortable tap target
                child: AbsorbPointer(
                  absorbing: _isEnabled,
                  child: TextField(
                    controller: controller,
                    // onTap: onTap,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    readOnly: readOnly,
                    textInputAction: TextInputAction.search,
                    style: CustomTextStyles.bodyLargeGray800,
                    decoration: InputDecoration(
                      isDense: true,
                      // properly padded/search icon with aligned baseline
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                        child: SvgPicture.asset(
                          'assets/icons/svg/search.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      hintText: hintText,
                      hintStyle: CustomTextStyles.bodyLargeGray800.copyWith(
                        height: 1.35,
                      ),
                      filled: true,
                      fillColor: appTheme.gray50,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: outline, width: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Spacing between search and chips
          if (suggestions.isNotEmpty) const SizedBox(height: 6.0),

          // Chips now sit on the page's background (not inside the card/grey box)
          if (suggestions.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
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
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        ),
      ),
    );
  }
}
