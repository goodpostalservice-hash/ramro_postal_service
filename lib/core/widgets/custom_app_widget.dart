import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

TextStyle tableHeader() {
  return const TextStyle(
    color: Colors.black87,
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
  );
}

TextStyle contentHeader() {
  return const TextStyle(
    color: Colors.black87,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );
}

Container header(String header) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    child: Text(
      header,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

Container darkHeader(String header) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
    child: Text(
      header,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

// TODO Bottom navigation screens appbar
AppBar titleAppBar(String title) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

AppBar backAppBar(String title, BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: appTheme.gray25,
    automaticallyImplyLeading: true,
    centerTitle: true,
    leadingWidth: 70,
    leading: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Material(
        color: appTheme.gray50,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pop(context),
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: appTheme.black,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
