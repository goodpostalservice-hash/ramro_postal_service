import 'package:flutter/material.dart';

class TurnInstructionBanner extends StatelessWidget {
  final String instruction;
  final String distance;
  final String maneuver;

  const TurnInstructionBanner({
    required this.instruction,
    required this.distance,
    required this.maneuver,
    super.key,
  });

  IconData _maneuverIcon(String type) {
    switch (type) {
      case 'turn-left':
        return Icons.turn_left;
      case 'turn-right':
        return Icons.turn_right;
      case 'straight':
      default:
        return Icons.straight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F9D58),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              _maneuverIcon(maneuver),
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                instruction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              distance,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
