import 'dart:io';

import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

class NoInternetConnection extends StatefulWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  State<NoInternetConnection> createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/banners/no_internet_found.jpg"),
              const SizedBox(height: 20.0),
              const Text(
                  'Sorry, we are enable to connect with a server. Please check your connection or try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15.0)),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await checkInternetConnection() == true
                        ? Navigator.pop(context)
                        : null;
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.redColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  child: Text("Try Again".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
