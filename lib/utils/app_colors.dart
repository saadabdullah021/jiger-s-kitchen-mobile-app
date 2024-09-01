import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = fromHex('#60BA62');
  static Color redColor = fromHex('#F55E66');
  static Color orangeColor = fromHex('#FF7700');
  static Color dividerGreyColor = fromHex('#F2F2F2');
  static Color homeblack = fromHex("#333333");
  static Color newOrderGrey = fromHex("#737373");
  static Color appColor = fromHex('#60BA62');
  static Color dialougBG = fromHex('#F9F9F9');
  static Color textFiledGrey = fromHex("#979494");
  static Color lightGreyColor = fromHex("#F8F8F8");
  static Color lightappColor = fromHex('#f28095');
  static Color borderColor = fromHex('#E0E4F5');
  static Color secondaryColor = fromHex('#261854');
  static Color textGreyColor = fromHex('#F3F3F3');
  static Color textBlueColor = fromHex('#4B545A');
  static Color numColor = fromHex('#5A6274');
  static Color appIconColor = fromHex('#B8BABF');
  static Color textBlackColor = fromHex('#0F0B03');
  static Color textWhiteColor = fromHex('#FFFFFF');
  static Color lightBlue = fromHex('#007AFF');
  static Color cyanColor = fromHex('#4DEEEC');
  static Color gradient1 = fromHex('#22B0FF');
  static Color gradient2 = fromHex('#ABFEBA');
  static Color greenColor = fromHex('#39F5BB');
  static Color yellowColor = fromHex('#FFE094');
  static Color jetBlackColor = fromHex('#343434');
  static Color greyColor = fromHex("#656565");
  static Color containerBg = Colors.grey.withOpacity(0.2);
  //DashBoard
  static Color dashBoardBg1 = fromHex("#FFE8E9");
  static Color dashBoardText1 = fromHex("#FF535C");

  static Color dashBoardBg2 = fromHex("#E1F0FF");
  static Color dashBoardText2 = fromHex("#1482FF");

  static Color dashBoardBg3 = fromHex("#FAE8FF");
  static Color dashBoardText3 = fromHex("#E279FF");

  static Color dashBoardBg4 = fromHex("#E8FFF2");
  static Color dashBoardText4 = fromHex("#60BA62");

  static Color dashBoardBg5 = fromHex("#FFF6E8");
  static Color dashBoardText5 = fromHex("#FF9E07");

  static Color dashBoardBg6 = fromHex("#FAFEDC");
  static Color dashBoardText6 = fromHex("#9BAD0F");

  static Color dashBoardBg7 = fromHex("#FFE8E8");
  static Color dashBoardText7 = fromHex("#FF6B6B");
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
