import 'package:flutter/material.dart';

import '../resource/color.dart';

Container headingText(double width, String menuText, String actionText) {
  return Container(
    padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(menuText,
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: AppColors.blackBold)),
        Container(
          child: Row(
            children: <Widget>[
              Text(actionText, style: TextStyle(color: AppColors.lightGrey)),
              if ('See All' == actionText)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      color: AppColors.lightGrey, size: 18.0),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

TextStyle menuHeading() {
  return TextStyle(fontSize: 12.0, color: AppColors.lightGrey);
}

TextStyle addressHeading() {
  return TextStyle(fontSize: 15.0, color: AppColors.highlightBlackColor);
}

TextStyle menuList() {
  return TextStyle(fontSize: 15.0, color: AppColors.blackBold);
}

TextStyle menuHeadingList() {
  return const TextStyle(
      fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold);
}

TextStyle amountHeadingList() {
  return const TextStyle(
      fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold);
}

TextStyle normalTextStyle() {
  return const TextStyle(
      fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.bold);
}

// register
InputDecoration textFormFieldDecoration(String hint) {
  return InputDecoration(
    isDense: true,
    hintText: hint,
    fillColor: Colors.white,
    hintStyle: TextStyle(
        color: AppColors.fieldHint,
        fontSize: 14.0,
        fontWeight: FontWeight.normal),
    border: InputBorder.none,
  );
}

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

InputDecoration formInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
  );
}

InputDecoration passwordInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

InputDecoration commonBoxBorder() {
  return InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

BoxDecoration customBoxDecoration(int status) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
          color: status == 1 ? AppColors.primary : AppColors.borderColor),
      color: status == 1 ? AppColors.primary : Colors.white);
}

customNormalAppBar(String title, Color color, Color textColor) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: color,
    title: Text(title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
  );
}

MaterialButton longButtons(String title, Function fun,
    {Color color = Colors.blue, Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: () {},
    textColor: textColor,
    color: color,
    height: 45,
    minWidth: 600,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
