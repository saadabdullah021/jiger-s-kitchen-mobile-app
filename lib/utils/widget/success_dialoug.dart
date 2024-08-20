import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void showDialogWithAutoDismiss(
    {BuildContext? context,
    String? img,
    String? heading,
    String? text,
    bool? autoDismiss,
    bool? showBtn,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText}) {
  showDialog(
    context: context!,
    builder: (BuildContext context) {
      autoDismiss == true
          ? Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop();
            })
          : null;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SvgPicture.asset(
              img!,
              height: 80.0,
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  heading!,
                  style: headingStyle,
                ),
                const SizedBox(height: 8.0), // Space between title and subtitle
                Text(text!, style: textStyle),
              ],
            ),
          ],
        ),
        actions: [
          // Optional button to close the dialog manually
          showBtn == true
              ? TextButton(
                  onPressed: onBtnTap,
                  child: Visibility(
                    visible: showBtn == true,
                    child: Text(btnText!),
                  ),
                )
              : const SizedBox(),
        ],
      );
    },
  );
}
