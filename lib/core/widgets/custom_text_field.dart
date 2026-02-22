import 'package:flutter/material.dart';

import '../constants/app_export.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.hint = 'Enter your phone number',
    this.isReadOnly = false,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool isReadOnly;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(color: color, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    final Color border = appTheme.gray400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(10),
        //   FilteringTextInputFormatter.digitsOnly,
        // ],
        style: CustomTextStyles.bodyMediumBlack14_400,
        onChanged: onChanged,
        validator: validator,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          // Reserve one line of space always so height doesn't change on error
          // helperText: ' ',
          helperStyle: const TextStyle(height: 1),

          // Make the input compact and consistent
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          filled: true,

          fillColor: appTheme.white,
          hintText: hint,
          hintStyle: CustomTextStyles.bodyMediumGray400,

          // Same border in all states (except error color)
          border: _border(border),
          enabledBorder: _border(border),
          focusedBorder: _border(border),
          errorBorder: _border(Colors.red.shade400),
          focusedErrorBorder: _border(Colors.red.shade400),

          // (Optional) control error text size/spacing
          errorStyle: const TextStyle(fontSize: 12, height: 1.1),
        ),
      ),
    );
  }
}
