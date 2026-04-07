import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../resource/color.dart';
import '../../../../resource/data.dart';
import '../../../../resource/string.dart';
import '../../../../utility/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String vehicle = 'Today Request';
  late double width, height;
  bool _switchValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      appBar: customNormalAppBar('Request', Colors.white, AppColors.blackBold),
      body: Container(
        child: Column(
          children: <Widget>[
            // history menu
            menu(),

            // overall widget
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // show cancelled rides
                    // showCancelled(),

                    // history list
                    historyList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      height: 65.0,
      width: double.infinity,
      child: ListView.builder(
        itemCount: ListData.menu.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                vehicle = ListData.menu[index]['name'];
                for (int i = 0; i < ListData.menu.length; i++) {
                  ListData.menu[i]['status'] = 0;
                }
                ListData.menu[index]['status'] = 1;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              decoration: customBoxDecoration(ListData.menu[index]['status']),
              padding: const EdgeInsets.only(
                left: 30.0,
                top: 2.0,
                bottom: 2.0,
                right: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ListData.menu[index]['name'],
                    style: TextStyle(
                      color: ListData.menu[index]['status'] == 1
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showCancelled() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        left: 10.0,
        right: 10.0,
      ),
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppStrings.show_cancelled_ride,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.blackBold,
            ),
          ),
          CupertinoSwitch(
            value: _switchValue,
            // activeTrackColor: AppColors.highlightBlackColor,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget historyList() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
                left: 10.0,
                right: 10.0,
              ),
              margin: const EdgeInsets.only(bottom: 15.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Parcel Delivery",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackBold,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "View more",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackBold,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: AppColors.lightGrey,
                                size: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // location point
                  Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // pickup drop up
                        Container(
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            height: 10.0,
                                            width: 10.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              color:
                                                  AppColors.highlightBlackColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                            width: 1.0,
                                            child: DottedLine(
                                              dashGapLength: 1.0,
                                              direction: Axis.vertical,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width - 80,
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                      ),
                                      child: Text(
                                        "Daraz warehouse 02, Baneshwor",
                                        style: TextStyle(
                                          color: AppColors.highlightBlackColor,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(top: 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 10.0,
                                            width: 1.0,
                                            child: DottedLine(
                                              dashGapLength: 1.0,
                                              direction: Axis.vertical,
                                            ),
                                          ),
                                          Container(
                                            height: 10.0,
                                            width: 10.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width - 80.0,
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 10.0,
                                      ),
                                      child: Text(
                                        "Kalinchowk 02, Bhaktapur",
                                        style: TextStyle(
                                          color: AppColors.highlightBlackColor,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(90.0),
                          child: CachedNetworkImage(
                            height: 50.0,
                            width: 50.0,
                            imageUrl:
                                "https://console.kr-asia.com/wp-content/uploads/2018/09/Food-Delivery-M-Size-1.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/banners/ic_app_card_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: AppColors.lightGrey),

                  // request
                  Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "View Parcel Detail".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          child: const Row(
                            children: <Widget>[
                              Text(
                                'Rating (4.5)',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Icon(Icons.star, color: Colors.orange),
                              ),
                            ],
                          ),
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
    );
  }
}
