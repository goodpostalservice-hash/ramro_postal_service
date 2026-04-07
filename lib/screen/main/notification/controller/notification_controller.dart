import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/network/network_dio.dart';
import '../modal/campaign_response_model.dart';
import '../modal/my_notification_response_model.dart';

class NotificationController extends BaseController {
  List<CampaignResponseModel> resultList = <CampaignResponseModel>[].obs;
  List<MyNotificationResponseModel> resultNotificationList =
      <MyNotificationResponseModel>[].obs;
  RxBool isToLoadMore = true.obs;

  final isButtonVisible = true.obs;

  @override
  onInit() {
    super.onInit();
    loadNotification();
    // loadCampaign();
  }

  void handleClick() {
    if (isButtonVisible.value == true) {
      isButtonVisible.value = false;
    } else {
      isButtonVisible.value = true;
    }
  }

  deleteNotification(String id, int index) async {
    final map = <String, dynamic>{'id': id};

    try {
      final result = await restClient.request(
        ApiConstant.deleteNotification,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          resultNotificationList.removeAt(index);
          update();
          // clear the list to replace with new value
          // resultNotificationList.clear();
        }
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  loadNotification() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.notification,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          resultNotificationList.clear();

          List<dynamic> myList = [];
          myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = MyNotificationResponseModel.fromJson(myList[i]);
            resultNotificationList.add(responseData);
          }

          isToLoadMore.value = false;
          resultNotificationList.add(
            MyNotificationResponseModel(
              title: "Hello",
              body: "Test notification",
            ),
          );
          resultNotificationList.add(
            MyNotificationResponseModel(
              title: "Hello",
              body: "Test notification 2",
            ),
          );
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  sendNotification(
    String title,
    String content,
    int isGlobal,
    int? userId,
  ) async {
    final map = <String, dynamic>{
      "title": title,
      "body": content,
      "is_global": isGlobal,
      "user_id": userId,
    };
    try {
      final result = await restClient.request(
        ApiConstant.notification,
        Method.POST,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value

          if (result.data["success"] = true) {
            print("notification sent");
          } else {
            print("error sending notification");
          }
        }
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }

  loadCampaign() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.campaign,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          resultList.clear();

          List<dynamic> myList = [];
          myList = result.data;
          for (int i = 0; i < myList.length; i++) {
            var responseData = CampaignResponseModel.fromJson(myList[i]);
            resultList.add(responseData);
          }
          isToLoadMore.value = true;
        }
      } else {
        isToLoadMore.value = false;
      }
    } on Exception {
      // in exception, redirect the route to internet connection issue
      // Get.offAllNamed('/no_internet');
      showErrorMessage(
        'Something went wrong while fetching data. Try again later.',
      );
    }
  }
}
