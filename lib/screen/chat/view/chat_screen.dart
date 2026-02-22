import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ramro_postal_service/core/constants/app_constant.dart';
import 'package:ramro_postal_service/core/widgets/custom_app_widget.dart';
import 'package:ramro_postal_service/resource/color.dart';
import 'package:ramro_postal_service/screen/chat/controller/chat_controller.dart';
import 'package:ramro_postal_service/screen/chat/model/chat_model.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen(this.ridePickupId, this.isRideActive, {super.key});

  final int ridePickupId;
  final int isRideActive;
  @override
  Widget build(BuildContext context) {
    final chatController = TextEditingController();
    Get.put(ChatController(ridePickupId, isRideActive));
    return Scaffold(
      appBar: backAppBar("Chat Screen".toUpperCase()),
      body: StreamBuilder(
        stream: controller.getChatStream(), // The stream to listen to
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Display a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            // Handle errors
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                    child: GroupedListView<Chat, DateTime>(
                        padding: const EdgeInsets.all(8.0),
                        reverse: true,
                        order: GroupedListOrder.DESC,
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
                        groupBy: (message) => DateTime(2024),
                        elements: snapshot.data,
                        groupHeaderBuilder: (Chat message) => const SizedBox(),
                        itemBuilder: (context, Chat message) => Align(
                              alignment: message.sender ==
                                      AppConstant.loggedInUserType.toUpperCase()
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Card(
                                elevation: 8.0,
                                color: message.sender ==
                                        AppConstant.loggedInUserType
                                            .toUpperCase()
                                    ? AppColors.primary
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    message.message!,
                                  ),
                                ),
                              ),
                            ))),
                Stack(children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              decoration: const InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              List<Map<String, dynamic>> chat = [];
                              for (var i = 0; i < snapshot.data.length; i++) {
                                Chat one = snapshot.data[i];

                                chat.add(one.toJson());
                              }
                              chat.add(Chat(
                                      message: chatController.text,
                                      sender: AppConstant.loggedInUserType ==
                                              'driver'
                                          ? 'DRIVER'
                                          : 'MERCHANT',
                                      timestamp: DateTime.now().toString())
                                  .toJson());
                              controller.driverSendChat(chat);
                              chatController.clear();
                            },
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ); // Handle the case when there's no data
          } else {
            return Column(
              children: [
                Expanded(
                    child: GroupedListView<Chat, DateTime>(
                        padding: const EdgeInsets.all(8.0),
                        reverse: true,
                        order: GroupedListOrder.DESC,
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
                        groupBy: (message) => DateTime(2024),
                        elements: controller.chatList,
                        groupHeaderBuilder: (Chat message) => const SizedBox(),
                        itemBuilder: (context, Chat message) => Align(
                              alignment: message.sender == 'DRIVER'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Card(
                                elevation: 8.0,
                                color: message.sender == 'DRIVER'
                                    ? AppColors.primary
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    message.message!,
                                  ),
                                ),
                              ),
                            ))),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     color: Colors.grey.shade300,
                //   ),
                //   child: TextField(
                //     decoration: const InputDecoration(
                //         contentPadding: EdgeInsets.all(12),
                //         hintText: 'Type your message here...'),
                //     onSubmitted: (text) {
                //       final message = Message(
                //           text: text, date: DateTime.now(), isSentByMe: true);
                //       setState(() {
                //         messages.add(message);
                //       });
                //     },
                //   ),
                // )
                Stack(children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              decoration: const InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              List<Map<String, dynamic>> myList = [];

                              myList.add(Chat(
                                      message: chatController.text,
                                      sender: AppConstant.loggedInUserType ==
                                              'driver'
                                          ? 'DRIVER'
                                          : 'MERCHANT',
                                      timestamp: DateTime.now().toString())
                                  .toJson());

                              controller.driverSendChat(myList);
                              chatController.clear();
                            },
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ); // Display your UI with the data
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
