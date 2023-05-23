// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../utils/my_screensize.dart';

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

  static Widget vButtonProgressLoader({double? width, double? height, Color? color, String? labelText}) {
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
         labelText ?? 'Loading',
          style: TextStyle(color: color ?? Colors.white),
        ), // Replace with your desired text
      ],
    );
  }



  static Widget vPostShimmering({required BuildContext context}){

    
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 48),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));

   
 
  }

   static Widget vPostPaginationShimmering({required BuildContext context}){
    
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 25),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));

   
 
  }
}
