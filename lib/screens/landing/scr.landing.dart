// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/screens/landing/pages/comments.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/my_bottom_sheet.dart';
import '';

class LandingScreen extends StatefulWidget {
  final User user;
  const LandingScreen({super.key, required this.user});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final String _userName = "user_0012001";
  final String _imgCategory = "Drawing";
  final String _userEmail = "user_0012001@gmail.com";
  int _pageIndex = 0;
  final Logger logger = Logger();
  late FirebaseFirestore firebaseFirestore;
  bool _isDataLoading = false;
  String _dropDownValue = "All Category";
  String _likes = "23";
  String _comments = "30";
  final String _uploadedTime = "12, june 2023";

  @override
  void initState() {
    super.initState();
    logger.d("I am Landing Screen");
    firebaseFirestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: MyColors.secondColor),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            // vActionItems(),
          ],
        ),
        drawer: Drawer(
            width: MyScreenSize.mGetWidth(context, 70), child: vDrawerItems()),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: MyColors.firstColor,
          onPressed: () {
            mShowBottomSheet();
          },
          child: const Icon(
            Icons.upload,
            color: MyColors.fourthColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: HomeBottomNavBar(
          pageIndex: _pageIndex,
          fabLocation: FloatingActionButtonLocation.centerDocked,
          // shape: const CircularNotchedRectangle(),
          shape: const CircularNotchedRectangle(),
          callback: (int pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
        ),
        body: _pageIndex == 0
            ? _isDataLoading
                ? GFShimmer(
                    child: Container(
                    color: Colors.black38,
                    width: MyScreenSize.mGetWidth(context, 80),
                    height: MyScreenSize.mGetHeight(context, 60),
                    child: const Text("This is"),
                  ))
                : Column(
                    children: [
                      vCategoryDropdown(),
                      SizedBox(
                        height: 6,
                      ),
                      vPostList(),
                    ],
                  )
            : _pageIndex == 1
                ? Center(child: Text(_pageIndex.toString()))
                : _pageIndex == 2
                    ? Center(child: Text(_pageIndex.toString()))
                    : Center(child: Text(_pageIndex.toString())));
  }

  Widget vActionItems() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _userName,
          style: const TextStyle(color: MyColors.secondColor),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.secondColor,
                width: .8,
              )),
          child: const CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        )
      ],
    );
  }

  Widget vDrawerItems() {
    return Container(
      color: Colors.white,
      // width: MyScreenSize.mGetWidth(context, 60),
      child: ListView(
        children: [
          vDrawerHeader(),
          ListTile(
            title: const Text(
              "Community Feeds",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "My Timeline",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Share",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Feedback",
            ),
            leading: const Icon(Icons.feedback),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Sign out",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget vDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: MyColors.secondColor),
      accountName: Text(
        _userName,
      ),
      accountEmail: Text(
        _userEmail,
      ),
      currentAccountPicture: const CircleAvatar(
        child: Image(image: AssetImage("assets/images/user.png")),
      ),
    );
  }

  mShowBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MyBottomSheet(callback:
              (String imgUri, String imgCategory, String caption) async {
            Post post = Post(
                email: widget.user.email,
                caption: caption,
                imgUri: imgUri,
                category: imgCategory,
                ts: DateTime.now().millisecondsSinceEpoch.toString());

            await MyFirestoreService.mUploadPost(
                    firebaseFirestore: firebaseFirestore, post: post)
                .then((value) async {
              if (value) {
                await Future.delayed(const Duration(milliseconds: 3000))
                    .then((value) {
                  // c: dismiss bottomSheet
                  Navigator.pop(context);
                });

                setState(() {
                  logger.d("Set state called");
                });
              }
            });
          });
        });
  }

  Widget vPostList() {
    return Expanded(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: ((context, index) {
            return vItem();
          })),
    );
  }

  Widget vCategoryDropdown() {
    return Container(
      height: MyScreenSize.mGetHeight(context, 6),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          isExpanded: true,
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.white,
          value: _dropDownValue,
          onChanged: (newValue) {
            setState(() {
              _dropDownValue = newValue!;
              logger.d("Clicked: $newValue");
            });
          },
          items: [
            'All Category',
            'Drawing',
            'Engraving',
            'Iconography',
            'Painting',
            'Sculpture'
          ]
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget vCatAndCap() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              // height: MyScreenSize.mGetHeight(context, 1),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: MyColors.thirdColor),
              child: Text(
                _imgCategory,
                style: TextStyle(color: MyColors.secondColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Some quick example text to build on the card"),
          ],
        ),
      ],
    );
  }

  Widget vItem() {
    return GFCard(
      // color: Colors.white,
      elevation: 5,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.asset(
        'assets/images/3399_mainfoto_05.jpg',
        fit: BoxFit.cover,
      ),
      showImage: true,
      title: GFListTile(
        margin: EdgeInsets.only(bottom: 6),
        shadow: BoxShadow(color: Colors.white),
        color: Colors.white,
        avatar: GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        titleText: _userName,
        subTitleText: _uploadedTime,
      ),
      content: vCatAndCap(),
      buttonBar: GFButtonBar(
        padding: EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeButton(),
          vCommentButton(),
        ],
      ),
    );
  }

  Widget vLikeButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GFAvatar(
          backgroundColor: Colors.black12 /* GFColors.PRIMARY */,
          size: GFSize.SMALL,
          child: Icon(
            Icons.favorite_outline,
            color: MyColors.secondColor,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "Likes",
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          _likes,
          style: TextStyle(color: Colors.black54),
        )
      ],
    );
  }

  Widget vCommentButton() {
    return InkWell(
      onTap: () {
        mOnClickCommentButton();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            size: GFSize.SMALL,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.comment,
              color: MyColors.secondColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Comments",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            _comments,
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }

  void mOnClickCommentButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage();
    }));
  }
}
