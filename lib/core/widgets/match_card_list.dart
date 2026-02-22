import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

class MatchCardList extends StatefulWidget {
  const MatchCardList({Key? key}) : super(key: key);

  @override
  State<MatchCardList> createState() => _MatchCardListState();
}

class _MatchCardListState extends State<MatchCardList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 30.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child:  Column(
            children: <Widget>[
              /// header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0)
                    ),
                    color: ColorManager.cardHeaderGreyColor
                ),
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Match 6", style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black87
                      )),
                    ),
                    Expanded(
                      child: Text("Dec 17, 2022", style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13.0, color: Colors.black54
                      ), textAlign: TextAlign.end),
                    )
                  ],
                ),
              ),

              /// information
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)
                  ),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("assets/icons/avengerswhite_logo.png", height: 50.0),
                            const SizedBox(width: 10.0),
                            const Flexible(
                              child: Text("Pokhara Avengers", style: TextStyle(
                                  fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.bold),
                                  maxLines: 2, textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: 30.0,
                      height: 3.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Flexible(
                              child: Text("Lumbini All Stars", style: TextStyle(
                                  fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.bold),
                                  maxLines: 2, textAlign: TextAlign.center),
                            ),
                            const SizedBox(width: 10.0),
                            Image.asset("assets/images/team_logo.png", height: 50.0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
