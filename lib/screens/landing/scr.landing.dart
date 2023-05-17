
import 'package:art_blog_app/screens/landing/widgets/bottom_nav.dart';
import 'package:art_blog_app/screens/landing/widgets/my_bottom_sheet.dart';
import 'package:art_blog_app/utils/my_colors.dart';
import 'package:art_blog_app/utils/my_screensize.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final String _userName = "user_0012001";
  final String _userEmail = "user_0012001@gmail.com";
  int _pageIndex = 0;
  final Logger logger = Logger( );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            vActionItems(),
          ],
        ),
        drawer: Drawer(
            width: MyScreenSize.mGetWidth(context, 70), child: vDrawerItems()),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: MyColors.firstColor,
          onPressed: () {
            // mShowBottomSheet();
            showModalBottomSheet(
              useSafeArea: true,
                context: context,
                builder: (context) {
                  return MyBottomSheet(callback: () {
                  });
                });

            /*   BottomSheet(
              builder: (context) {
                return Container(
                  height: MyScreenSize.mGetHeight(context, 50),
                  child: Text("Bottom Sheet"),
                );
              },
              onClosing: () {
                logger.d("Close");
              },
            ); */
          },
          // tooltip: localizations.buttonTextCreate,
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
          shape: CircularNotchedRectangle(),
          callback: (int pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
        ),
        body: _pageIndex == 0
            ? Center(child: Text(_pageIndex.toString()))
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
    showDialog(
        context: context,
        builder: (context) {
          return MyBottomSheet(callback: () {
            Logger().d("Clicked");
          });
        });
  }
}
