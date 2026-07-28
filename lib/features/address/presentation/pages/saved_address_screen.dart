import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/address/presentation/controllers/address_controller.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/saved_address_dialog.dart';

class SavedAddressScreen extends GetView<AddressController> {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        body: controller.isLoading.value == true
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
                              onTap: () {
                                final selectedAddress =
                                    controller.resultList[index];
                                final destination = controller.parseCoordinates(
                                  selectedAddress.coordinates,
                                );
                                if (destination == null) {
                                  Get.snackbar(
                                    "Invalid coordinates",
                                    "The selected address does not contain valid coordinates.",
                                  );
                                  return;
                                }

                                showSavedAddressDetailsDialog(
                                  context,
                                  destinationLocation: destination,
                                  address: selectedAddress.address ?? "",
                                  onDelete: () async {
                                    final id = selectedAddress.id;
                                    if (id != null) {
                                      await controller.deleteSavedAddress(
                                        id,
                                        context,
                                      );
                                    }
                                  },
                                  onShare: () {
                                    SharePlus.instance.share(
                                      ShareParams(
                                        subject: selectedAddress.label,
                                        text:
                                            '${selectedAddress.address ?? ''}\n'
                                            'https://www.google.com/maps/search/?api=1&query='
                                            '${destination.latitude},${destination.longitude}',
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                        color: appTheme.gray25,
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
                                          Text(
                                            controller
                                                    .resultList[index]
                                                    .label ??
                                                "Address Name",
                                            style: CustomTextStyles
                                                .bodyMediumBlack_14_500,
                                          ),
                                          const SizedBox(height: 3.0),
                                          Text(
                                            controller
                                                    .resultList[index]
                                                    .address ??
                                                "",
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
