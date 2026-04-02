import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = "#F58433".fromHex;
  static Color darkGrey = "#525252".fromHex;
  static Color grey = "#737477".fromHex;
  static Color lightGrey = "#9E9E9E".fromHex;
  static Color primaryOpacity70 = "#B3f4f8f7".fromHex;
  static Color redColor = "#F11616".fromHex;
  static Color bottomNavigationGreyColor = "828282".fromHex;
  static Color colorWhite = "#ffffff".fromHex;
  static Color tableHeaderBackgroundColor = "#D9D9D9".fromHex;

  // card color
  static Color cardLightDarkColor = "#525252".fromHex;
  static Color cardHeaderGreyColor = "D9D9D9".fromHex;

  //new colors
  static Color darkPrimary = "#d0e1dd".fromHex;
  static Color grey1 = "#707070".fromHex;
  static Color grey2 = "#797979".fromHex;
  static Color white = "#FFFFFF".fromHex;
  static Color error = "#e61f34".fromHex; //red color
  static Color drakBlue = "#224379".fromHex;
  static Color skyBlue = "#5896C5".fromHex;
  static Color lightBlue = "#E0F1F9".fromHex;
  static Color blackishBlue = "#19282F".fromHex;
  static Color grey3 = "#e3e3e3".fromHex;
  static Color skyBlue2 = "#309FF8".fromHex;
  static Color backgroundColor = "#F4F8F7".fromHex;
  static Color redLogoColor = '#D72229'.fromHex;
  static Color logoYellowColor = '#EB8B2A'.fromHex;
}

extension HexColor on String {
  Color get fromHex {
    String hexColorString = this;
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
