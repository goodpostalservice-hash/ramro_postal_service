import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ramro_postal_service/resource/color.dart';
import 'package:ramro_postal_service/screen/common/about/controller/help_controller.dart';

class FAQScreen extends GetView<AboutController> {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AboutController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() => controller.faqQuestions.isNotEmpty
          ? ListView.builder(
              itemCount: controller.faqQuestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: Text(
                    controller.faqQuestions[index].question != null
                        ? "${index + 1}. ${controller.faqQuestions[index].question}"
                        : "",
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: controller.isExpanded.value == true
                      ? const Icon(Icons.minimize)
                      : const Icon(Icons.add),
                  children: <Widget>[
                    ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18.0),
                        title: Text(controller.faqQuestions[index].answer ?? "",
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500))),
                  ],
                  onExpansionChanged: (bool expanded) {
                    controller.isExpanded.value = expanded;
                  },
                );
              })
          : const Center(
              child: CircularProgressIndicator(),
            )),
    );
  }
}
