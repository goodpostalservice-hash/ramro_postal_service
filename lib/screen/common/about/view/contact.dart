import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/resource/color.dart';
import 'package:ramro_postal_service/screen/common/about/controller/help_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AboutController());
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear from you! Please reach out to us with any questions, concerns, or feedback.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xff2E3C5D),
                height: 1.5,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15.0),
            InkWell(
              onTap: () {
                launchUrl(Uri.parse("mailto:inquiry@ramropostalservice.com"));
              },
              child: const Text(
                "Our email: inquiry@ramropostalservice.com",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
