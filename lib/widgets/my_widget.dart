import 'package:art_blog_app/utils/my_screensize.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class MyWidget {
  static Future<dynamic> vShowWarnigDialog(
      {required BuildContext context,
      required String message,
      String? buttonText,
      String? desc}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: message,
        desc: desc ?? "",
        btnOk: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(400, MyScreenSize.mGetHeight(context, 1)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
          child: Text(buttonText ?? "Dismiss"),
        )).show();
  }

  static Widget vButtonProgressLoader({double? width, double? height, Color? color}) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: width ?? 24,
            height: height ?? 24,
            child: CircularProgressIndicator(
              color: color ?? Colors.white,
              strokeWidth: 2,
            )), // Customize the CircularProgressIndicator as needed
      const  SizedBox(
            width:
                8), // Add some spacing between the CircularProgressIndicator and text
        Text(
          'Loading',
          style: TextStyle(color: color ?? Colors.white),
        ), // Replace with your desired text
      ],
    );
  }
}
