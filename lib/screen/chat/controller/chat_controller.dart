import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/core/constants/api_constant.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';
import 'package:ramro_postal_service/screen/chat/model/chat_model.dart';

class ChatController extends BaseController {
  ChatController(
    this.ridePickupId,
    this.isRideActive,
  );
  final int ridePickupId;
  final int isRideActive;
  Timer? timer;
  List<dynamic> chatListToPost = <Map<String, dynamic>>[].obs;
  RxList<Chat> chatList = <Chat>[].obs;
  RxBool isChatLoading = false.obs;

  Stream<List<Chat>?> getChatStream() async* {
    while (isRideActive == 1) {
      await Future.delayed(const Duration(seconds: 5));
      yield await driverGetChat();
    }
  }

  driverSendChat(List<Map<String, dynamic>> chat) async {
    try {
      // chatListToPost.add({
      //   'message': message,
      //   'sender':
      //       AppConstant.loggedInUserType == 'driver' ? 'DRIVER' : 'MERCHANT',
      //   'timestamp': DateTime.now().toString(),
      //   'username': 'Rajesh'
      // });
      final map = {"pickup_id": ridePickupId, "chat": chat};

      final result =
          await restClient.request(ApiConstant.postChat, Method.POST, map);

      if (result.data['success'] == true) {
        if (result is dio.Response) {
          print('chat sent sucessfully');
        }

        // redirect to main screen
      } else {
        // chatList.last.remove();
      }
    } on SocketException {
      showErrorMessage('No Internet !');
    }
  }

  Future<List<Chat>?> driverGetChat() async {
    try {
      isChatLoading.value = true;
      final map = <String, dynamic>{};

      final result = await restClient.request(
          'https://app.ramropostalservice.com/api/chat?pickup_id=$ridePickupId',
          Method.GET,
          map);

      if (result != null) {
        if (result is dio.Response) {
          isChatLoading.value = false;
          List<dynamic> myList = result.data;
          List<Chat> listToPost = [];

          for (int i = 0; i < myList.length; i++) {
            var responseData = Chat.fromJson(myList[i]);
            // chatList.add(responseData);
            listToPost.add(responseData);
          }
          return listToPost;
        }
      } else {
        isChatLoading.value = false;
        return null;
      }
    } on Exception {
      // showErrorMessage('Something went wrong. Please try again later.');
      return null;
    }
    return null;
  }

  @override
  void onInit() {
    // TODO: implement onInit

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      isRideActive == 1 ? driverGetChat() : null;
    });
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ChatController(ridePickupId, 0);
    getChatStream();
  }
}
