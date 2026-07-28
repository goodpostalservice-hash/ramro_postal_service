import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';



class RamroAddressColors {
  RamroAddressColors._();

  static Color background(BuildContext context) {
    return appTheme.gray25;
  }

  static Color card(BuildContext context) {
    // Prefer appTheme.whiteA700 / theme.colorScheme.surface if available.
    return Theme.of(context).colorScheme.surface;
  }

  static Color primary(BuildContext context) {
    // Prefer appTheme.orangeBase if available.
    return appTheme.orangeBase;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withOpacity(0.55);
  }

  static Color border(BuildContext context) {
    return Theme.of(context).colorScheme.outline.withOpacity(0.14);
  }

  static Color error(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static Color mapBackground(BuildContext context) {
    return primary(context).withOpacity(0.08);
  }

  static Color mapLine(BuildContext context) {
    return primary(context).withOpacity(0.18);
  }
}

class AddressLabelOption {
  final String label;
  final IconData icon;

  const AddressLabelOption({required this.label, required this.icon});
}

class RamroAddressHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const RamroAddressHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = RamroAddressColors.textPrimary(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: textColor,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class RamroSectionLabel extends StatelessWidget {
  final String text;

  const RamroSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: RamroAddressColors.textSecondary(context),
        letterSpacing: 1.2,
      ),
    );
  }
}

class RamroAddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const RamroAddressTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = RamroAddressColors.primary(context);
    final textColor = RamroAddressColors.textPrimary(context);
    final borderColor = RamroAddressColors.border(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor.withOpacity(0.32),
          fontWeight: FontWeight.w400,
        ),
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: RamroAddressColors.textSecondary(context),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Icon(icon, color: primaryColor, size: 19),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: RamroAddressColors.card(context),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: RamroAddressColors.error(context),
            width: 1.3,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: RamroAddressColors.error(context),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class RamroLabelSelector extends StatelessWidget {
  final List<AddressLabelOption> options;
  final String selectedLabel;
  final ValueChanged<String> onChanged;

  const RamroLabelSelector({
    super.key,
    required this.options,
    required this.selectedLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        final isSelected = selectedLabel == option.label;
        final isLast = option == options.last;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: RamroLabelChip(
              label: option.label,
              icon: option.icon,
              isSelected: isSelected,
              onTap: () => onChanged(option.label),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class RamroLabelChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RamroLabelChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = RamroAddressColors.primary(context);
    final textColor = RamroAddressColors.textPrimary(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : RamroAddressColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : RamroAddressColors.border(context),
              width: 1.4,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : RamroAddressColors.textSecondary(context),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : textColor.withOpacity(0.62),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RamroSaveAddressButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RamroSaveAddressButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = RamroAddressColors.primary(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.7),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                )
              : Row(
                  key: const ValueKey('text'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Save Address',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class RamroAddressSnackBar {
  RamroAddressSnackBar._();

  static void show(BuildContext context, {required String message}) {
    final primaryColor = RamroAddressColors.primary(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class RamroMapGridPainter extends CustomPainter {
  final Color lineColor;
  final Color roadColor;
  final Color blockColor;

  const RamroMapGridPainter({
    required this.lineColor,
    required this.roadColor,
    required this.blockColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    const step = 28.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.35, size.height),
      roadPaint,
    );

    final blockPaint = Paint()..color = blockColor;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.05, 60, 40),
        const Radius.circular(4),
      ),
      blockPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.55, 45, 35),
        const Radius.circular(4),
      ),
      blockPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.6, 70, 30),
        const Radius.circular(4),
      ),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RamroMapGridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.roadColor != roadColor ||
        oldDelegate.blockColor != blockColor;
  }
}
