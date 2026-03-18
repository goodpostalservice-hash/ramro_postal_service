import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ramro_postal_service/screen/common/search/presentation/view/show_search_on_map_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/error/toast.dart';
import '../../../../resource/color.dart';

class ShowQRScreen extends StatefulWidget {
  String? location_detail, longitude, latitude;
  ShowQRScreen({
    super.key,
    this.location_detail,
    this.longitude,
    this.latitude,
  });

  @override
  State<ShowQRScreen> createState() => _ShowQRScreenState();
}

class _ShowQRScreenState extends State<ShowQRScreen> {
  bool isLoading = false;
  bool _isChecked = false;
  String? _selectedValue;
  final List<String> _dropdownValues = ['Home', 'Work', 'Other'];
  bool saveLocationLoading = false;
  final TextEditingController addressKnownTypeController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'QR Generated'.toUpperCase(),
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: QrImageView(
                    data: widget.location_detail.toString(),
                    version: QrVersions.auto,
                    size: 300,
                    gapless: false,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                child: Text(
                  widget.location_detail.toString(),
                  style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.latitude != null ||
                              widget.longitude != null) {
                            List<dynamic> myList = widget.location_detail!
                                .split(" ");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowSearchOnMapScreen(
                                  latitude: double.parse(widget.latitude!),
                                  longitude: double.parse(widget.longitude!),
                                  address: widget.location_detail!,
                                  houseno: myList[0],
                                  street: myList[2],
                                  zone: "",
                                  sub: "",
                                ),
                              ),
                            );
                          }
                          showErrorMessage(
                            "could not show this address in map",
                          );
                        },
                        child: SizedBox(
                          height: 50.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Open in Map'.toUpperCase())],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String locationInfo =
                              'Ramro Postal Service \n\nI am sharing my location with you i.e. ${widget.location_detail}. ';

                          onShare(context, locationInfo);
                        },
                        child: SizedBox(
                          height: 50.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Share Location'.toUpperCase())],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: SizedBox(
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Print QR'.toUpperCase())],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        insetPadding: const EdgeInsets.all(10.0),
                        contentPadding: const EdgeInsets.all(15.0),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5.0),
                                        margin: const EdgeInsets.only(
                                          bottom: 10.0,
                                        ),
                                        child: const Text(
                                          '- Select To Continue -',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.0,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: const Text(
                                              'Select Address Type',
                                            ),
                                            value: _selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue = value;
                                              });
                                            },
                                            items: _dropdownValues.map((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 20.0,
                                        ),
                                        padding: const EdgeInsets.only(
                                          left: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              addressKnownTypeController,
                                          decoration: const InputDecoration(
                                            hintText: 'eg. Address name',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20.0,
                                        ),
                                        padding: const EdgeInsets.only(
                                          left: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Set As Default Address',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          value: _isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              _isChecked = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey[300]!,
                                            ),
                                            child: const SizedBox(
                                              height: 50.0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (saveLocationLoading ==
                                                    false) {
                                                  saveLocationLoading = true;
                                                  saveQR();
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  saveLocationLoading
                                                  ? AppColors.disabledPrimaryBtn
                                                  : AppColors.primary,
                                            ),
                                            child: SizedBox(
                                              height: 50.0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    saveLocationLoading
                                                        ? 'Loading'
                                                        : 'Save',
                                                    style: const TextStyle(
                                                      color: Colors.white,
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading
                      ? AppColors.disabledPrimaryBtn
                      : AppColors.primary,
                ),
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? AppColors.disabledPrimaryBtn
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        isLoading
                            ? 'Please wait'.toUpperCase()
                            : 'Save Address'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // open google map by url_launcher
  void _launchURL(String imageUrl) async {
    if (!await launch(imageUrl)) throw 'Could not launch $imageUrl';
  }

  // open share me option
  onShare(BuildContext context, String location) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      location,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// in this section, api is called in the function to save the qr
  /// data into our server. you can modify as you pleased
  void saveQR() async {
    var addLocationJSON = {
      'longitude': widget.longitude.toString(),
      'latitude': widget.latitude.toString(),
      'ishomeaddress': true,
      'add_on_map': true,
      'delevery_address': widget.location_detail.toString(),
      'address_type': addressKnownTypeController.text == ''
          ? _selectedValue.toString()
          : addressKnownTypeController.text,
      'is_default': _isChecked ? '1' : '0',
      'address_map': widget.location_detail.toString(),
    };

    print(addLocationJSON.toString());

    var dio = Dio();
    final response = await dio
        .post(
          ApiConstant.addLocation,
          options: Options(
            headers: {
              'Accept': 'application/json',
              "Authorization": "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
          data: FormData.fromMap(addLocationJSON),
        )
        .catchError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          showErrorMessage('Something went wrong while registering.');
        });

    final responseData = response.data;
    if (response.statusCode == 200) {
      setState(() {
        if (responseData['success'] == true) {
          isLoading = false;
          showSuccessMessage(responseData['message'].toString());

          Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard',
            (Route<dynamic> route) => false,
          );
        } else {
          isLoading = false;
          showErrorMessage(responseData['message'].toString());
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorMessage(responseData['message'].toString());
    }
  }
}
