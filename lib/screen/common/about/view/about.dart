import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/resource/color.dart';
import 'package:ramro_postal_service/screen/common/about/controller/help_controller.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AboutController());
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(
        () => controller.aboutUs.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 10.0,
                  ),
                  child: Text(
                    controller.aboutUs.value == ""
                        ? "empty"
                        : controller.aboutUs.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2E3C5D),
                      height: 1.5,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
