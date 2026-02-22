import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import '../../../main/map/screen/map_mode.dart';
import '../../controller/my_qr_controller.dart';

class MyQRScreen extends GetView<MyQRController> {
  const MyQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // appBar: backAppBar("Location QR".toUpperCase()),
      body: Obx(() => controller.resultList.isNotEmpty
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  margin: const EdgeInsets.all(7.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                      "assets/icons/dummy_user.jpg",
                                      height: 45.0,
                                      width: 45.0),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'QR Profile',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13.0),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'My saved address',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 20.0, bottom: 10.0),
                              child:
                                  Divider(height: 3.0, color: Colors.grey[400]),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(right: 40.0),
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                    color: Colors.orange),
                                child: const Text(
                                  'Default Address',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(bottom: 4.0),
                            //   width: 270.0,
                            //   height: 270.0,
                            //   child: QrImage(
                            //     data: controller.resultList[0].deleveryAddress
                            //         .toString(),
                            //     version: QrVersions.auto,
                            //     size: 260,
                            //     gapless: false,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              child: Text(
                                  controller.resultList[0].addressMap
                                              .toString() !=
                                          'null'
                                      ? controller.resultList[0].addressMap
                                          .toString()
                                          .capitalize!
                                      : 'Address missing',
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                  maxLines: 3),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2.0),
                        child: GridView.count(
                          padding: const EdgeInsets.all(0.0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            controller.resultList.length,
                            (index) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final MyQRController myQRController =
                                          Get.find();

                                      return AlertDialog(
                                        insetPadding:
                                            const EdgeInsets.all(10.0),
                                        contentPadding:
                                            const EdgeInsets.all(15.0),
                                        content: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      '${controller.resultList[index].isDefault} Select Action',
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        icon: const Icon(Icons.close))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 0.0, bottom: 20.0),
                                                padding: const EdgeInsets.only(
                                                    left: 2.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey[300]!,
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                child:
                                                    Obx(() => CheckboxListTile(
                                                          title: const Text(
                                                            'Set As Default Address',
                                                            style: TextStyle(
                                                                fontSize: 15.0),
                                                          ),
                                                          value: controller
                                                                      .resultList[
                                                                          index]
                                                                      .isDefault
                                                                      .toString() ==
                                                                  '1'
                                                              ? true
                                                              : controller
                                                                  .myCheckBoxValue
                                                                  .value,
                                                          onChanged: (value) {
                                                            if (controller
                                                                    .resultList[
                                                                        index]
                                                                    .isDefault
                                                                    .toString() ==
                                                                '0') {
                                                              showSuccessMessage(
                                                                  'Updating. Please wait.');
                                                              myQRController
                                                                  .changeCheckBoxValue(
                                                                      value!);
                                                              controller.isDefaultQR(
                                                                  controller
                                                                      .resultList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  value
                                                                      ? '1'
                                                                      : '0');
                                                            } else {
                                                              showErrorMessage(
                                                                  'You have already set this as your default address.');
                                                            }
                                                          },
                                                        )),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors.blue,
                                                    ),
                                                    child: const SizedBox(
                                                      height: 50.0,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Obx(() => ElevatedButton(
                                                        onPressed: () {
                                                          controller.deleteSelectedQR(
                                                              controller
                                                                  .resultList[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              index.toString());
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: controller
                                                                  .isDeleting
                                                                  .value
                                                              ? Colors.redAccent
                                                              : Colors.red,
                                                        ),
                                                        child: SizedBox(
                                                          height: 50.0,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                controller
                                                                        .isDeleting
                                                                        .value
                                                                    ? 'Please wait'
                                                                    : 'Delete',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey[400]!.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller
                                              .resultList[index].isDefault ==
                                          1)
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 4.0,
                                              bottom: 5.0),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                              color: Colors.orange),
                                          child: Text(
                                            controller
                                                .resultList[index].addressType
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white),
                                          ),
                                        )
                                      else
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 4.0,
                                              bottom: 5.0),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                              color: Colors.blue),
                                          child: Text(
                                            controller
                                                .resultList[index].addressType
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4.0),
                                        width: 105.0,
                                        height: 105.0,
                                        child: QrImageView(
                                          data: controller
                                              .resultList[index].deleveryAddress
                                              .toString(),
                                          version: QrVersions.auto,
                                          size: 260,
                                          gapless: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, right: 7.0),
                                        child: Text(
                                            controller.resultList[index]
                                                        .addressMap
                                                        .toString() !=
                                                    'null'
                                                ? controller.resultList[index]
                                                    .addressMap
                                                    .toString()
                                                    .capitalize!
                                                : 'Address missing',
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 13.0),
                                            textAlign: TextAlign.center,
                                            maxLines: 2),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                  // child: GridView.count(
                  //   physics: const BouncingScrollPhysics(),
                  //   shrinkWrap: true,
                  //   crossAxisCount: 2,
                  //   children: List.generate(controller.resultList.length, (index) {
                  //     return InkWell(
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //
                  //             final MyQRController myQRController = Get.find();
                  //
                  //             return AlertDialog(
                  //               insetPadding: const EdgeInsets.all(10.0),
                  //               contentPadding: const EdgeInsets.all(15.0),
                  //               content: StatefulBuilder(
                  //                 builder: (BuildContext context, StateSetter setState) {
                  //                   return Container(
                  //                     width: MediaQuery.of(context).size.width,
                  //                     child: Column(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: [
                  //
                  //                         Container(
                  //                           padding: const EdgeInsets.all(5.0),
                  //                           margin: const EdgeInsets.only(bottom: 10.0),
                  //                           child: Row(
                  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                             children: <Widget>[
                  //                               const Text('Select Action', style: TextStyle(
                  //                                 fontSize: 18.0, fontWeight: FontWeight.bold,
                  //                               ),),
                  //                               IconButton(
                  //                                   onPressed: () => Navigator.pop(context),
                  //                                   icon: Icon(Icons.close)
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //
                  //                         // Container(
                  //                         //   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  //                         //   decoration: BoxDecoration(
                  //                         //       border: Border.all(color: Colors.grey[300]!, width: 1.0),
                  //                         //       borderRadius: BorderRadius.circular(10.0)
                  //                         //   ),
                  //                         //   width: MediaQuery.of(context).size.width,
                  //                         //   child: DropdownButtonHideUnderline(
                  //                         //     child: DropdownButton<String>(
                  //                         //       hint: const Text('Select Address Type'),
                  //                         //       value: myQRController.selectedValue,
                  //                         //       onChanged: (value) {
                  //                         //         myQRController.changeSelectedValue(value!);
                  //                         //       },
                  //                         //       items: _dropdownValues.map((String value) {
                  //                         //         return DropdownMenuItem<String>(
                  //                         //           value: value,
                  //                         //           child: Text(value),
                  //                         //         );
                  //                         //       }).toList(),
                  //                         //     ),
                  //                         //   ),
                  //                         // ),
                  //
                  //                         Container(
                  //                           margin: const EdgeInsets.only(top: 0.0, bottom: 20.0),
                  //                           padding: const EdgeInsets.only(left: 2.0),
                  //                           decoration: BoxDecoration(
                  //                               border: Border.all(color: Colors.grey[300]!, width: 1.0),
                  //                               borderRadius: BorderRadius.circular(10.0)
                  //                           ),
                  //                           child: Obx(() => CheckboxListTile(
                  //                             title: const Text('Set As Default Address', style: TextStyle(
                  //                                 fontSize: 15.0
                  //                             ),),
                  //                             value: myQRController.myCheckBoxValue.value,
                  //                             onChanged: (value) {
                  //                               myQRController.changeCheckBoxValue(value!);
                  //                             },
                  //                           )),
                  //                         ),
                  //                         Row(
                  //                           mainAxisAlignment: MainAxisAlignment.end,
                  //                           children: [
                  //                             ElevatedButton(
                  //                               onPressed: () {
                  //                                 Navigator.of(context).pop();
                  //                               },
                  //                               style: ElevatedButton.styleFrom(
                  //                                 primary: Colors.blue,
                  //                               ),
                  //                               child: SizedBox(
                  //                                 height: 50.0,
                  //                                 child: Column(
                  //                                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                                   mainAxisAlignment: MainAxisAlignment.center,
                  //                                   children: const <Widget>[
                  //                                     Text('Cancel', style: TextStyle(
                  //                                         color: Colors.white
                  //                                     ),),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             const SizedBox(width: 10.0),
                  //                             ElevatedButton(
                  //                               onPressed: () {
                  //                                 controller.deleteSelectedQR(controller.resultList[index].id.toString(), index.toString());
                  //                               },
                  //                               style: ElevatedButton.styleFrom(
                  //                                 primary: Colors.red,
                  //                               ),
                  //                               child: Container(
                  //                                 height: 50.0,
                  //                                 child: Column(
                  //                                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                                   mainAxisAlignment: MainAxisAlignment.center,
                  //                                   children: <Widget>[
                  //                                     Text('Delete', style: const TextStyle(
                  //                                         color: Colors.white
                  //                                     ),),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       },
                  //       child: Container(
                  //         margin: const EdgeInsets.all(4.0),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(5.0),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey[400]!.withOpacity(0.2),
                  //               spreadRadius: 2,
                  //               blurRadius: 4,
                  //               offset: const Offset(0, 3), // changes position of shadow
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //
                  //             if (controller.resultList[index].isDefault == 0)
                  //               Container(
                  //                 padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 5.0),
                  //                 decoration: const BoxDecoration(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(10.0),
                  //                       bottomRight: Radius.circular(10.0),
                  //                     ),
                  //                     color: Colors.orange
                  //                 ),
                  //                 child: const Text('Default Address', style: TextStyle(
                  //                     fontSize: 11.0, color: Colors.white
                  //                 ),),
                  //               ),
                  //
                  //             Container(
                  //               margin: const EdgeInsets.only(bottom: 4.0),
                  //               width: 105.0,
                  //               height: 105.0,
                  //               child: QrImage(
                  //                 data: controller.resultList[index].deleveryAddress.toString(),
                  //                 version: QrVersions.auto,
                  //                 size: 260,
                  //                 gapless: false,
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                  //               child: Text(controller.resultList[index].addressMap.toString() != 'null' ?
                  //               controller.resultList[index].addressMap.toString().capitalize! :
                  //               'Address missing', style: const TextStyle(
                  //                   color: Colors.black54, fontSize: 13.0
                  //               ), textAlign: TextAlign.center, maxLines: 2),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },),
                  // ),
                  ),
            )
          : Center(
              child: controller.isEmpty.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('No Address found',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4.0),
                        const Text(
                          'You have not saved any address yet',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () => Get.to(const MapScreen()),
                            child: const Text('Generate QR'))
                      ],
                    )
                  : const CircularProgressIndicator(),
            )),
    );
  }
}
