import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../resource/color.dart';
import '../../../../resource/data.dart';
import '../../../../resource/string.dart';
import '../../../../resource/variable.dart';
import '../../../scanner/presentation/view/new_scanner.dart';
import '../../map/screen/map_mode.dart';

class HomeScreen extends StatefulWidget {
  static String bookingID = '';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String active_status = 'No Active Ride', curr_add = 'Refresh your new location..';
  String active_status = 'No Active Ride',
      curr_add = 'Ambler Bay, Ontario, Canada';
  late double width, height;
  var statusBarHeight;
  var activeJSON = {};

  @override
  void initState() {
    super.initState();

    // get current pin
    _getCurrentLocation();

    // get banner
    showBanner();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              // top menu
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                    //   child: const Text('Ramro Postal Service', style: TextStyle(
                    //     fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87
                    //   ),),
                    // ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/icons/logo.png", width: 120.0),
                    ),

                    // Container(
                    //   width: double.infinity,
                    //   child: InkWell(
                    //     onTap: () => _getCurrentLocation(),
                    //     child: Row(
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: const EdgeInsets.only(right: 5.0),
                    //           child: Icon(Icons.location_on, color: AppColors.lightGrey, size: 20.0),
                    //         ),
                    //         Flexible(
                    //           child: Text(curr_add, style:
                    //           TextStyle(color: AppColors.lightGrey, fontSize: 13.0), overflow: TextOverflow.ellipsis),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 4.0),
                    //           child: Icon(curr_add == "Refresh your new location.." ? Icons.refresh : Icons.arrow_forward_ios_sharp, color: AppColors.lightGrey, size: 18.0),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              // service gridview
              serviceGrid(),

              // whats new
              whatsNew(),

              // where  would you like to go
              search(),

              // restaurant listing
              // restaurant(),

              // get discount widget
              getDiscount(),

              // food banner
              getFood(),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceGrid() {
    return Container(
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0.0),
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        shrinkWrap: true,
        children: List.generate(ListData.service_list.length, (index) {
          return InkWell(
            onTap: () async {
              if (ListData.service_list[index]['name']
                      .toString()
                      .toLowerCase() ==
                  "Generate QR".toLowerCase()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              } else if (ListData.service_list[index]['name']
                      .toString()
                      .toLowerCase() ==
                  "Scan QR".toLowerCase()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerPage(),
                  ),
                );
              } else if (ListData.service_list[index]['name']
                      .toString()
                      .toLowerCase() ==
                  "Rental".toLowerCase()) {
                Navigator.pushNamed(context, '/rental_home');
              } else {}
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: CachedNetworkImage(
                      height: 60.0,
                      imageUrl: ListData.service_list[index]['image']
                          .toString(),
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Image.asset(
                        "assets/banners/ic_app_card_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    ListData.service_list[index]['name'].toString(),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget whatsNew() {
    return Container(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 25.0,
        bottom: 20.0,
      ),
      width: width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.whats_new,
            style: TextStyle(
              color: AppColors.blackBold,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),

          // slider option
          slideMenu(),

          // slider carousel
          carousel(),
        ],
      ),
    );
  }

  // whats new slider menu
  Widget slideMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      height: 35.0,
      child: ListView.builder(
        itemCount: ListData.whatsNewList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10.0),
            padding: const EdgeInsets.only(
              left: 14.0,
              right: 14.0,
              top: 7.0,
              bottom: 7.0,
            ),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.primary : Colors.white,
              border: Border.all(
                color: index == 0 ? AppColors.primary : AppColors.lightGrey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              ListData.whatsNewList[index]['view'].toString(),
              style: TextStyle(
                color: index == 0 ? Colors.white : AppColors.lightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  final int _current = 0;
  int index = 1;
  Widget carousel() {
    return Container(
      child: bannerList.isNotEmpty
          ? CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                viewportFraction: 0.9,
                initialPage: 0,
                onPageChanged: (index, _) {
                  setState(() {
                    // _current = index;
                  });
                },
                autoPlay: true,
              ),
              items: bannerList.map<Widget>((imageURL) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        _launchURL(imageURL['url'].toString());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: 200.0,
                            imageUrl: imageURL['image_url'],
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Image.asset(
                              "assets/banners/ic_app_card_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/banners/ic_app_card_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          : SizedBox(
              height: 200.0,
              width: double.infinity,
              child: Image.asset(
                "assets/banners/ic_app_card_placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget search() {
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 10.0,
        left: 12.0,
        right: 12.0,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Features",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: AppColors.blackBold,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AppColors.borderColor, width: 1),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 10.0,
                  ),
                  child: InkWell(
                    onTap: () => Get.toNamed('/myqr'),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.normalBG,
                          ),
                          child: Icon(
                            Icons.qr_code,
                            color: AppColors.lightGrey,
                            size: 32.0,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'My QR List',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackBold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Your QR are list here. Tap to view more.',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.only(top: 15.0),
          //   child: Row(
          //     children: <Widget>[
          //       Container(
          //         padding: const EdgeInsets.all(7.0),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(90.0),
          //           color: AppColors.borderColor,
          //         ),
          //         child: Icon(Icons.search, color: AppColors.lightGrey),
          //       ),
          //       Expanded(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Padding(
          //               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          //               child: Text(AppStrings.search_for_location, style: TextStyle(
          //                   color: AppColors.lightGrey, fontWeight: FontWeight.w400,
          //                   fontSize: 15.0
          //               )),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 4.0),
          //               child: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.lightGrey, size: 18.0),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // restaurant widget
  Widget restaurant() {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        left: 12.0,
        right: 12.0,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppStrings.featured_restaurant,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackBold,
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        'See All',
                        style: TextStyle(color: AppColors.lightGrey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: AppColors.lightGrey,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // listview
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            height: 270.0,
            child: ListView.builder(
              itemCount: ListData.foodList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        height: 160.0,
                        width: 300.0,
                        fit: BoxFit.cover,
                        imageUrl: ListData.foodList[index]['image'],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Container(
                        padding: const EdgeInsets.all(7.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 3.0),
                            Text(
                              ListData.foodList[index]['name'].toString(),
                              style: TextStyle(
                                color: AppColors.blackBold,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              ListData.foodList[index]['tag'].toString(),
                              style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 14.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.star, color: Colors.orange),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4.0,
                                      right: 6.0,
                                    ),
                                    child: Text(
                                      ListData.foodList[index]['rating']
                                          .toString(),
                                      style: const TextStyle(fontSize: 13.0),
                                    ),
                                  ),
                                  Text(
                                    '(${ListData.foodList[index]['review_no']} Ratings)',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    height: 15.0,
                                    width: 1.0,
                                    color: AppColors.lightGrey,
                                  ),
                                  Text(
                                    'Delivery Rs.${ListData.foodList[index]['delivery_amt']}',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // get discount screen
  Widget getDiscount() {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        left: 12.0,
        right: 12.0,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: width,
            child: Text(
              AppStrings.get_discounts,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: AppColors.blackBold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
            child: Image.asset("assets/banners/free_ride_banner.png"),
          ),
          Text(
            AppStrings.invite_friends,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.blackBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Text(
              AppStrings.invite_friend,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: AppColors.highlightBlackColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              AppStrings.static_info,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: AppColors.highlightBlackColor,
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: width - 135.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'Share your code: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'KMC81',
                              style: TextStyle(
                                color: AppColors.blackBold,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 45.0,
                        width: 1.0,
                        color: AppColors.borderColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.content_copy,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Center(
                    child: Container(
                      width: 62.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Invite'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // get food screen
  Widget getFood() {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        left: 12.0,
        right: 12.0,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
            alignment: Alignment.center,
            child: Image.asset("assets/banners/food_banner.jpg", height: 140.0),
          ),
          Text(
            AppStrings.invite_friends_food,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.blackBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Text(
              AppStrings.static_info_food,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: AppColors.highlightBlackColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              AppStrings.static_info,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: AppColors.highlightBlackColor,
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: width - 135.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'Share your code: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'SIMA200',
                              style: TextStyle(
                                color: AppColors.blackBold,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 45.0,
                        width: 1.0,
                        color: AppColors.borderColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.content_copy,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Center(
                    child: Container(
                      width: 62.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Invite'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    if (AppVariable.pick_location != '') {
      curr_add = AppVariable.pick_location;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      AppVariable.current_latitude = position.latitude;
      AppVariable.current_longitude = position.longitude;
    });
    // getCurrentLocationName( position.latitude, position.longitude);
  }

  Future<void> getCurrentLocationName(double latitude, double longitude) async {
    final pinURL =
        "https://easytaxinepal.com/nominatim/reverse?format=json&lat=$latitude&lon=$longitude&zoom=16&addressdetails=1";
    var dio = Dio();
    final response = await dio
        .get(pinURL, options: Options(headers: {}))
        .catchError((error, stackTrace) {
          log("Error Data: $error");
        });

    final responseData = response.data;
    setState(() {
      AppVariable.pick_location = responseData['display_name'].toString();
      curr_add = responseData['display_name'].toString();
    });
  }

  // view slider
  List bannerList = [];
  showBanner() async {
    var dio = Dio();

    final response = await dio
        .get(
          ApiConstant.slider,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
        )
        .catchError((error, stackTrace) {
          log("Error: ${error['data']['message']}");
        });

    final responseData = response.data;
    if (response.statusCode == 200) {
      setState(() {
        bannerList.add(responseData[0]);
      });
    } else {
      log("Error: ${responseData['message']}");
    }
  }

  // open url
  void _launchURL(String imageUrl) async {
    if (!await launch(imageUrl)) throw 'Could not launch $imageUrl';
  }
}
