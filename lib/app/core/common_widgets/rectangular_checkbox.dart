import 'package:flutter/material.dart';

import '../values/colors.dart';

class RectangularCheckBox extends StatefulWidget {
  const RectangularCheckBox({super.key});

  @override
  State<RectangularCheckBox> createState() => _RectangularCheckBoxState();
}

class _RectangularCheckBoxState extends State<RectangularCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return SColors.grey.withOpacity(0.1);
    }

    return Checkbox(
      checkColor: Colors.blue,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      side: BorderSide(
        color: SColors.grey.withOpacity(0.6),
        width: 1.5,
      ),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
