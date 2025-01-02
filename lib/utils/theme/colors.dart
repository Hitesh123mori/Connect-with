import 'package:flutter/material.dart';

hexStringToColors(String hexColor){
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}


class  AppColors {
  static Map theme = themes["theme1"];

  static Map themes = {

    "theme1": {
      "primaryColor":hexStringToColors("#0d2136"),
      "backgroundColor":hexStringToColors("#E9E9E9"),
      "secondaryColor":hexStringToColors("#FFFFFF"),
      "tertiaryColor":hexStringToColors("#0B0B0B")
    },
  };


}
