import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/resource/color.dart';
import 'package:ramro_postal_service/screen/about/controller/help_controller.dart';

class PrivacyPolicyScreen extends GetView<AboutController> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AboutController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() => controller.privacyContent.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 10.0),
                child: Text(
                  controller.privacyContent.value
                  // "Welcome to Ramro Postal Service – Your Ultimate Map Companion! At Ramro Postal Service , we're passionate about simplifying your journey, whether it's a daily commute, a road trip adventure, or exploring new destinations. Our mission is to provide you with a reliable, user-friendly map application that enhances your navigation experience.",
                  ,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff2E3C5D,
                      ),
                      height: 1.5,
                      fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            )),
    );
  }
}
