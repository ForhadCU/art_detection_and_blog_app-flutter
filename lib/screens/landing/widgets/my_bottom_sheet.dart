// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';

import 'package:art_blog_app/utils/custom_text.dart';
import 'package:art_blog_app/utils/my_screensize.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:tflite/tflite.dart';

import '../../../const/keywords.dart';
import '../../../controller/my_services.dart';
import '../../../models/model.image_details.dart';
import '../../../utils/my_colors.dart';
import '../../../utils/my_date_format.dart';

class MyBottomSheet extends StatefulWidget {
  final Function callback;

  const MyBottomSheet({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List<ImageDetailsModel> _imgDetailModelList = [];
  late File _imgFile;
  late Map<String, dynamic> map = {};
  TextEditingController _textEditingControllerCaption =
      TextEditingController(text: '');
  bool _isVisible = false;
  bool _isUploadBtnLoading = false;
  bool _isGoogleBtnLoading = false;
  bool _isCaptionFieldVisible = false;
  bool _isScanning = false;
  final Logger logger = Logger();
  // bool _isShowNewBabyContents = false;

  @override
  void initState() {
    super.initState();
    /*    MyServices.determinePosition().then((value) {
      map = value;
    }); */
    // print('IsSignedIn: ${widget.isSignedIn}');
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCaption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* _imgDetailModelList.isNotEmpty
        ? print(
            'imageDetailsModelList 0th item: ${_imgDetailModelList[0].imgUri}')
        : null; */
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MyScreenSize.mGetHeight(context, 8),
              color: MyColors.firstColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Upload picture',
                    fontWeight: FontWeight.w400,
                    fontcolor: Colors.white,
                    fontsize: 20,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  //v: Caption
                  Visibility(
                    visible: _isCaptionFieldVisible,
                    child: TextField(
                      controller: _textEditingControllerCaption,
                      maxLines: 2,
                      maxLength: 200,
                      decoration: InputDecoration(
                          label: CustomText(
                            text: 'Caption',
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // v: Image preview
                  Container(
                    height: _imgDetailModelList.isNotEmpty
                        ? MyScreenSize.mGetHeight(context, 20)
                        : 0,
                    alignment: Alignment.center,
                    child: _imgDetailModelList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 1 /* _imgDetailModelList.length */,
                            // itemCount: _imgStrList.isEmpty ? 0 : _imgStrList.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: /* Utility.imageFromBase64String(
                                    _imgDetailModelList[index].imgUrl) ,*/
                                          Image.file(
                                        File(_imgDetailModelList[index]
                                            .getImgUrl),
                                        width: 120,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ))
                                  // CustomText(text: 'Text $index')
                                  ;
                            }))
                        : null,
                  ),

                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // v: local button
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _imgDetailModelList.clear();
                              //* for single image pick
                              /*     MyServices.mPickImgFromLocal()
                                        .then((value) {
                                      if (value != null) {
                                        setState(() { });    

                                      }
                                    }); */
                              // m: pick image from local storage
                              MyServices.mPickMultipleImageFromLocal()
                                  .then((value) {
                                if (value != null) {
                                  /*  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return Test(
                                        multipleImagesString:
                                            value[MyKeywords.multiImgUrls]);
                                  })); */

                                  // c: assign image Details Model list
                                  _imgDetailModelList = value;
                                  // c: Referesh screen for show image preview in the horizontal List view
                                  setState(() {});
                                }
                              });
                            },
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabled: false,
                                  isDense: true,

                                  // contentPadding: EdgeInsets.all(2),
                                  prefixIcon: Icon(
                                    Icons.file_upload,
                                    size: 24,
                                    color: MyColors.firstColor,
                                  ),
                                  label: CustomText(
                                    text: 'Local',
                                    fontWeight: FontWeight.w400,
                                    fontcolor: Colors.black45,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        // v: Camera button
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _imgDetailModelList.clear();

                              MyServices.mPickImgCamera().then((value) {
                                if (value != null) {
                                  // _imageString = value!;
                                  // _imgDetailModelList.add(value!);

                                  _imgDetailModelList.add(
                                      ImageDetailsModel.imageFromCamera(
                                          imgUrl:
                                              value[MyKeywords.singleImgUrls],
                                          latitude: map['lat'],
                                          longitude: map['long'],
                                          timestamp: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          /* caption:
                                            _textEditingControllerCaption.text, */
                                          date: MyDateForamt.mFormateDateDB(
                                              DateTime.now())));
                                  // c: Referesh screen for show image preview in the horizontal List view
                                  setState(() {});
                                }
                              });
                            },
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabled: false,
                                  isDense: true,

                                  // contentPadding: EdgeInsets.all(2),
                                  prefixIcon: Icon(
                                    Icons.camera,
                                    size: 24,
                                    color: MyColors.firstColor,
                                  ),
                                  label: CustomText(
                                    text: 'Camera',
                                    fontWeight: FontWeight.w400,
                                    fontcolor: Colors.black45,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // v: discard button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.firstColor),
                            onPressed: () {
                              // Navigator.pop(context);
                              // mCallBack();
                            },
                            child: CustomText(
                              text: 'Discard',
                              fontcolor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        // v: scan button
                        Expanded(
                          child: _isUploadBtnLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )
                                  ],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.firstColor),
                                  onPressed: () {
                                    _imgDetailModelList.isNotEmpty
                                        ? {mScanPicture()}
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: CustomText(
                                            text: 'Pick a photo',
                                          )));

                                    // c: [Deprecated] Save to Cloud
                                    // mSaveToCloud();
                                  },
                                  child: CustomText(
                                    text: 'Scan',
                                    fontcolor: Colors.white,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),

                  // e: for later
                  //Sign in with google
                  Visibility(
                      visible: _isVisible,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: Colors.black12,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Please Sign in with Google',
                                  fontcolor: Colors.black45,
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isGoogleBtnLoading
                                    ? Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : RawMaterialButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isGoogleBtnLoading =
                                                !_isGoogleBtnLoading;
                                          });
                                        },
                                        elevation: 2.0,
                                        constraints: BoxConstraints(
                                            maxWidth: 40,
                                            minWidth: 40,
                                            maxHeight: 40,
                                            minHeight: 40),
                                        shape: CircleBorder(),
                                        fillColor: Colors.white,
                                        // constraints: BoxConstraints(maxw),
                                        child: Image(
                                          image: AssetImage(
                                            "lib/assets/images/ic_google.png",
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //v: Methods

  void mShowSaveOption() {
    showFlexibleBottomSheet(
        bottomSheetColor: Colors.white,
        minHeight: 0,
        initHeight: 0.25,
        maxHeight: 1,
        anchors: [0, 0.5, 1],
        isSafeArea: true,
        context: context,
        builder: (BuildContext context, ScrollController scrollController,
                double bottomSheetOffset) =>
            Container(
              margin: EdgeInsets.only(top: 25, left: 8, bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: 'Save to',
                        fontsize: 12,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    splashColor: MyColors.firstColor,
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: MyColors.firstColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Local album'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    splashColor: MyColors.firstColor,
                    onTap: () {
                      Navigator.pop(context);
                      splashColor:
                      MyColors.firstColor;
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.cloud_circle_rounded,
                            color: MyColors.firstColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Cloud album'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void mSaveToCloud() {
    /*
        //save to cloud
    if (_isSignedIn) {
    _imgDetailModelList.isNotEmpty
        ? {
            setState(() {
              _isUploadBtnLoading =
                  !_isUploadBtnLoading;
            }),
            FirebaseStorageProvider
                    .mAddImageToFirebaseStorage(
                        email: _userEmail!,
                        imgFile:
                            _imgDetailModelList
                                .first
                                .imgFile!,
                        imgName:
                            _imgDetailModelList
                                .first.imgUri!
                                .substring(
                                    6, 15))
                .then((value) {
              if (value != null) {
                print(_userEmail);
                FirestoreProvider.mAddBabyGalleryDataToFirestore(
                    email: _userEmail!,
                    caption:
                        _textEditingControllerCaption
                            .text,
                    imgUrl:
                        "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
                    latitude: _imgDetailModelList
                        .first.latitude,
                    longitude:
                        _imgDetailModelList
                            .first.longitude,
                    timestamp:
                        _imgDetailModelList
                            .first.date,
                    date: _imgDetailModelList
                        .first.date,
                    imgFromCamera:
                        _imgDetailModelList
                            .first
                            .imgFromCamera!);
                widget.callback(_userEmail);
                Navigator.pop(context);

                /*    _imgDetailModelList[0]
                        .caption =
                    _textEditingControllerCaption
                        .value.text; */
              }
            })
          }
        : null;
  } else {
    setState(() {
      _isVisible = !_isVisible;
      /*   _isGoogleBtnLoading =
          !_isGoogleBtnLoading; */
    });
  }
*/
  }

  mCallBack() {
    widget.callback();
    Navigator.pop(context);
  }

  mScanPicture() async {
    
  /*   await Tflite.loadModel(
      model: 'assets/ai model/model_unquant.tflite',
      labels: 'assets/ai model/labels.txt',
    ); */
    logger.d("Model loaded");
  }
}
