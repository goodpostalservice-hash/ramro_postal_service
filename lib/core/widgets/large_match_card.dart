import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

class LargeMatchCard extends StatefulWidget {
  const LargeMatchCard({Key? key}) : super(key: key);

  @override
  State<LargeMatchCard> createState() => _LargeMatchCardState();
}

class _LargeMatchCardState extends State<LargeMatchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            /// header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                color: ColorManager.redColor,
              ),
              child: const Text(
                "NEXT MATCH - Nepal T20 League",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            /// information
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/avengerswhite_logo.png",
                            height: 50.0,
                          ),
                          const SizedBox(width: 10.0),
                          const Flexible(
                            child: Text(
                              "Pokhara Avengers",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      "V/S",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primary,
                        fontSize: 24.0,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Flexible(
                            child: Text(
                              "Lumbini All Stars",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(width: 10.0),

                          Image.asset(
                            "assets/images/team_logo.png",
                            height: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              color: Colors.white,
              child: const Divider(color: Colors.black, height: 1.0),
            ),

            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Dec 15, 2022",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: ColorManager.cardLightDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Starts from: 5:00 PM",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Dec 15, 2022",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: ColorManager.cardLightDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Starts from: 5:00 PM",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
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
      ),
    );
  }
}
