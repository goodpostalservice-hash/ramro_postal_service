import 'dart:math';

import 'package:flutter/material.dart';

class CenterLoadingBarImage extends StatefulWidget {
  const CenterLoadingBarImage({super.key});

  @override
  State<CenterLoadingBarImage> createState() => _CenterLoadingBarStateImage();
}

class _CenterLoadingBarStateImage extends State<CenterLoadingBarImage>
    with SingleTickerProviderStateMixin {
  var angle = 0;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    //if (animationController != null) animationController.dispose();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animationController.repeat();
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return Transform.rotate(
              angle: animationController.value * 2 * pi,
              child: child,
            );
          },
          // child: Image.asset(SAppAssets.logoProdLogo),
        ),
      ),
    );
  }
}

class CenterLoadingBar extends StatelessWidget {
  const CenterLoadingBar({super.key, this.loadingText = "Loading..."});

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class CenterLoadingBarWithLogo extends StatelessWidget {
  const CenterLoadingBarWithLogo({super.key, this.loadingText = "Loading..."});

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15,
              // backgroundImage: AssetImage(SAppAssets.logoProdLogo),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
