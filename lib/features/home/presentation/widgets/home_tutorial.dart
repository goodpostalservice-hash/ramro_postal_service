import 'package:flutter/material.dart';

class TutorialContent extends StatelessWidget {
  const TutorialContent({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.step,
    required this.totalSteps,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final int step;
  final int totalSteps;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width * 0.82)
          .clamp(0.0, 420.0)
          .toDouble(),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (i) {
              final isActive = i < step;
              final isCurrent = i == step - 1;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? iconColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
