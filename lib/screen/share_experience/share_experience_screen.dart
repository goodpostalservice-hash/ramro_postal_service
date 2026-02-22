import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_export.dart';

class ShareExperienceScreen extends StatefulWidget {
  const ShareExperienceScreen({super.key, required this.id});
  final int id;

  @override
  State<ShareExperienceScreen> createState() => _ShareExperienceScreenState();
}

class _ShareExperienceScreenState extends State<ShareExperienceScreen> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Destination',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You have reached your location!',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Share your experience:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Rate us and leave a comment:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildStarIcon(1),
                buildStarIcon(2),
                buildStarIcon(3),
                buildStarIcon(4),
                buildStarIcon(5),
              ],
            ),
            const SizedBox(height: 7.0),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AppButton(
                  label: 'Skip',

                  onPressed: () {
                    // Submit the experience and rating
                    // mapDirectionController.driverCompleteRide(context, widget.id);
                    Get.offNamed('/dashboard');
                  },
                ),
                AppButton(
                  label: 'Submit',

                  onPressed: () {
                    // Submit the experience and rating
                    // mapDirectionController.driverCompleteRide(context, widget.id);
                    Get.offNamed('/dashboard');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStarIcon(int starCount) {
    return IconButton(
      icon: Icon(
        starCount <= rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 32.0,
      ),
      onPressed: () {
        setState(() {
          rating = starCount;
        });
      },
    );
  }
}
