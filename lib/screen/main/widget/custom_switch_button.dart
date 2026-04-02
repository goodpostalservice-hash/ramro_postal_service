import 'package:flutter/material.dart';

class CustomSwitchButton extends StatefulWidget {
  final bool initialValue;
  final Function(bool value) onChanged;

  const CustomSwitchButton({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  CustomSwitchButtonState createState() => CustomSwitchButtonState();
}

class CustomSwitchButtonState extends State<CustomSwitchButton> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 7.0,
          bottom: 7.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _value ? Colors.green : Colors.red,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _value ? Icons.online_prediction : Icons.offline_bolt,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              _value ? 'Online' : 'Offline',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
