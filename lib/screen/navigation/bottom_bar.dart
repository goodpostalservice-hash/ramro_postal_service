import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final String duration;
  final String distance;
  final String arrivalTime;
  final VoidCallback onRecenter;
  final VoidCallback onExit;
  final VoidCallback? onExpand;

  const NavigationBottomBar({
    required this.duration,
    required this.distance,
    required this.arrivalTime,
    required this.onRecenter,
    required this.onExit,
    this.onExpand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12.0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Exit
                IconButton(
                  onPressed: onExit,
                  icon: const Icon(Icons.close, size: 28),
                ),

                // Duration + distance + arrival
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$distance • $arrivalTime",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const Spacer(),

                // Route Overview
                IconButton(
                  onPressed: onRecenter,
                  icon: const Icon(Icons.alt_route_rounded, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
