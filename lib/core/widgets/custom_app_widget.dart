import 'package:flutter/material.dart';

TextStyle tableHeader() {
  return const TextStyle(
    color: Colors.black87, fontSize: 13.0, fontWeight: FontWeight.bold
  );
}

TextStyle contentHeader() {
  return const TextStyle(
      color: Colors.black87, fontSize: 12.0, fontWeight: FontWeight.w400
  );
}

Container header(String header) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    child: Text(header, style: const TextStyle(color: Colors.white, fontSize: 18.0,
    fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  );
}

Container darkHeader(String header) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    child: Text(header, style: const TextStyle(color: Colors.black87, fontSize: 18.0,
        fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  );
}

// TODO Bottom navigation screens appbar
AppBar titleAppBar(String title) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Text(title, style: const TextStyle(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold
    )),
  );
}

AppBar backAppBar(String title) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: true,
    title: Text(title, style: const TextStyle(
        color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold
    )),
  );
}