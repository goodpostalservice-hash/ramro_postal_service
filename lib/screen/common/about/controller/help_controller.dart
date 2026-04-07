import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/screen/common/about/view/help_model.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/network/network_dio.dart';
import 'package:dio/dio.dart' as dio;

class AboutController extends BaseController {
  final isToLoadMore = false.obs;
  RxString aboutUs = "".obs;
  RxString privacyContent = "".obs;
  List<HelpModel> faqQuestions = <HelpModel>[].obs;
  RxBool isExpanded = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    getAboutUs();
    getPrivacyPolicy();
    getFAQ();
  }

  getAboutUs() async {
    try {
      final map = <String, dynamic>{};

      final result = await restClient.request(
        ApiConstant.aboutUs,
        Method.GET,
        map,
      );
      if (result != null) {
        aboutUs.value = result.data;
      } else {
        print("error on getting about us");
      }
    } on Exception {
      showErrorMessage('Something went wrong. Please try again later.');
    }
  }

  getPrivacyPolicy() async {
    try {
      final map = <String, dynamic>{};

      final result = await restClient.request(
        ApiConstant.privacyPolicy,
        Method.GET,
        map,
      );

      if (result != null) {
        privacyContent.value = result.data;
      } else {
        print("error on geeting about us");
      }
    } on Exception {
      showErrorMessage('Something went wrong. Please try again later.');
    }
  }

  getFAQ() async {
    try {
      final map = <String, dynamic>{};

      final result = await restClient.request(
        ApiConstant.faqQues,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          List<dynamic> myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = HelpModel.fromJson(myList[i]);
            faqQuestions.add(responseData);
          }
        }
      } else {}
    } on Exception {
      showErrorMessage('Something went wrong. Please try again later.');
    }
  }
}
