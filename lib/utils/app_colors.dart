import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = fromHex('#60BA62');
  static Color appColor = fromHex('#60BA62');
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
  static Color yellowColor = fromHex('#F7E584');
  static Color jetBlackColor = fromHex('#343434');
  static Color greyColor = fromHex("#656565");
  static Color containerBg = Colors.grey.withOpacity(0.2);
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
