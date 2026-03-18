import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/common/search/presentation/view/show_search_on_map_screen.dart';
import '../../controller/saved_address_controller.dart';

class SavedAddressScreen extends GetView<SavedAddressController> {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SavedAddressController());
    return Obx(
      () => Scaffold(
        backgroundColor: appTheme.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: appTheme.white,
          title: Text(
            "Saved Address",
            style: CustomTextStyles.titleLargeBlack20_500,
          ),
          actions: [
            controller.selectedId.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      List<String> qrList = [];
                      List<String> customerName = [];

                      for (var element in controller.resultList) {
                        for (var i = 0; i < controller.selectedId.length; i++) {
                          if (element.id == controller.selectedId[i]) {
                            final add = splitCoordinateString(
                              element.addressMap!,
                            );

                            qrList.add(add);
                            customerName.add(element.addressType!);
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.print),
                  )
                : const SizedBox(),
            controller.selectedId.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.deleteSelectedQR(
                          controller.selectedId.subject.value!,
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: controller.isToLoadMore.value == true
            ? const Center(child: CircularProgressIndicator())
            : controller.resultList.isNotEmpty
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(7.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(2.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.resultList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () {
                                controller.selectedId.add(
                                  controller.resultList[index].id!,
                                );
                                controller.selectedItems[index] =
                                    !controller.selectedItems[index];
                              },
                              onTap: controller.selectedId.isEmpty
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: const EdgeInsets.all(
                                              10.0,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(15.0),
                                            content: StatefulBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    StateSetter setState,
                                                  ) {
                                                    return SizedBox(
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  5.0,
                                                                ),
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  bottom: 10.0,
                                                                ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <Widget>[
                                                                const Text(
                                                                  'Select Action',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // Container(
                                                          //   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                                          //   decoration: BoxDecoration(
                                                          //       border: Border.all(color: Colors.grey[300]!, width: 1.0),
                                                          //       borderRadius: BorderRadius.circular(10.0)
                                                          //   ),
                                                          //   width: MediaQuery.of(context).size.width,
                                                          //   child: DropdownButtonHideUnderline(
                                                          //     child: DropdownButton<String>(
                                                          //       hint: const Text('Select Address Type'),
                                                          //       value: myQRController.selectedValue,
                                                          //       onChanged: (value) {
                                                          //         myQRController.changeSelectedValue(value!);
                                                          //       },
                                                          //       items: _dropdownValues.map((String value) {
                                                          //         return DropdownMenuItem<String>(
                                                          //           value: value,
                                                          //           child: Text(value),
                                                          //         );
                                                          //       }).toList(),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  top: 0.0,
                                                                  bottom: 20.0,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left: 2.0,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors
                                                                    .grey[300]!,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10.0,
                                                                  ),
                                                            ),
                                                            child: CheckboxListTile(
                                                              title: const Text(
                                                                'Set As Default Address',
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                              ),
                                                              value:
                                                                  controller
                                                                          .resultList[index]
                                                                          .isDefault ==
                                                                      1
                                                                  ? true
                                                                  : false,
                                                              onChanged: (value) {
                                                                controller
                                                                    .changeCheckBoxValue(
                                                                      value!,
                                                                    );
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppConstant.loggedInUserType ==
                                                                      'merchant'
                                                                  ? ElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            AppColors.primary,
                                                                      ),
                                                                      child: const SizedBox(
                                                                        height:
                                                                            50.0,
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children:
                                                                              <
                                                                                Widget
                                                                              >[
                                                                                Text(
                                                                                  'Print QR',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : ElevatedButton(
                                                                      onPressed: () {
                                                                        final add = splitCoordinateString(
                                                                          controller
                                                                              .resultList[index]
                                                                              .addressMap!,
                                                                        );

                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) => ShowSearchOnMapScreen(
                                                                                  latitude: double.parse(
                                                                                    controller.resultList[index].latitude!,
                                                                                  ),
                                                                                  longitude: double.parse(
                                                                                    controller.resultList[index].longitude!,
                                                                                  ),
                                                                                  address: add,
                                                                                  houseno: '',
                                                                                  street: '',
                                                                                  zone: "",
                                                                                  sub: '',
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            AppColors.primary,
                                                                      ),
                                                                      child: const SizedBox(
                                                                        height:
                                                                            50.0,
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children:
                                                                              <
                                                                                Widget
                                                                              >[
                                                                                Text(
                                                                                  'Show in map',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                              const Spacer(),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue,
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
                                                                    children: <Widget>[
                                                                      Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  controller.deleteQR(
                                                                    controller
                                                                        .resultList[index]
                                                                        .id!,
                                                                  );
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                                                    children: <Widget>[
                                                                      Text(
                                                                        'Delete',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  : () {
                                      controller.selectedItems[index] =
                                          !controller.selectedItems[index];
                                      if (controller.selectedId.contains(
                                        controller.resultList[index].id!,
                                      )) {
                                        controller.selectedId.remove(
                                          controller.resultList[index].id!,
                                        );
                                      } else {
                                        controller.selectedId.add(
                                          controller.resultList[index].id!,
                                        );
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: controller.selectedItems[index] == true
                                      ? Colors.green[200]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50.0,
                                      width: 50.0,
                                      margin: const EdgeInsets.only(
                                        bottom: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        color:
                                            controller.selectedItems[index] ==
                                                true
                                            ? Colors.green[200]
                                            : appTheme.gray25,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/svg/location_pin.svg',
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (controller
                                                  .resultList[index]
                                                  .isDefault ==
                                              1)
                                            Text(
                                              controller
                                                      .resultList[index]
                                                      .addressType ??
                                                  "Default Address",
                                              style: CustomTextStyles
                                                  .bodyMediumBlack_14_500,
                                            )
                                          else
                                            Text(
                                              controller
                                                      .resultList[index]
                                                      .addressType ??
                                                  "Unknown Address",
                                              style: CustomTextStyles
                                                  .bodyMediumBlack_14_500,
                                            ),
                                          const SizedBox(height: 3.0),
                                          Text(
                                            controller
                                                        .resultList[index]
                                                        .addressMap
                                                        .toString() !=
                                                    'null'
                                                ? controller
                                                      .resultList[index]
                                                      .addressMap
                                                      .toString()
                                                      .capitalize!
                                                : 'Address missing',
                                            style: CustomTextStyles
                                                .bodyMediumGray14_400,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: Text("No Saved Address.")),
      ),
    );
  }
}

String splitCoordinateString(String address) {
  List<String> addressParts = address.split(','); // Split the address by commas
  // Remove the last two words (latitude and longitude)
  List<String> remainingParts = addressParts.sublist(
    0,
    addressParts.length - 2,
  );
  String result = remainingParts.join(
    ',',
  ); // Join the remaining parts with commas
  return result;
}
