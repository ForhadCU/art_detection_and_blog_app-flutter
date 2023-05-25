// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/keywords.dart';
import 'package:flutter_application_1/controller/my_authentication_service.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/screens/art%20guide/scr.art_guide.dart';
import 'package:flutter_application_1/screens/landing/pages/comments.dart';
import 'package:flutter_application_1/screens/profile/scr_profile.dart';
import 'package:flutter_application_1/screens/signin/scr_signin.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/my_bottom_sheet.dart';

class LandingScreen extends StatefulWidget {
  final User user;
  const LandingScreen({super.key, required this.user});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final String _userName = "user_0012001";
  final String _imgCategory = "all category";
  final String _userEmail = "user_0012001@gmail.com";
  int _pageIndex = 0;
  final Logger logger = Logger();
  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isDataLoading = true;
  String _dropDownValue = "All Category";
  String _likes = "23";
  String _comments = "30";
  final String _uploadedTime = "12, june 2023";
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Post>? posts;
  late ScrollController _scrollController = ScrollController();
  late CollectionReference _collectionReferencePOST;
  late CollectionReference _collectionReferenceLIKER;

// >>
  @override
  void initState() {
    super.initState();
    logger.d("I am Init");
    _collectionReferencePOST = firebaseFirestore.collection(MyKeywords.POST);
    _collectionReferenceLIKER = firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .collection(MyKeywords.LIKER);

    mLoadData(); // c: Load latest 10 posts from firebase firestore

    mControlListViewSrolling(); // c: Post listView scroll listener for control pagination

    mAddCollectionReferencePOSTListener();
    mAddCollectionReferenceLIKERListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Landing Screen");
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
          shape: const CircularNotchedRectangle(),
          callback: (int pageIndex) {
            setState(() {
              _pageIndex = pageIndex;
            });
          },
        ),
        body: _pageIndex == 0
            ? vHome()
            : _pageIndex == 1
                ? ProfilePage()
                : null);
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
              "Art Guide",
            ),
            leading: const Icon(Icons.newspaper),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ArtGuideScreen();
              }));
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
            leading: const Icon(Icons.arrow_back),
            onTap: () {
              mOnClickSignOut();
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
        widget.user.displayName == null ? "User" : widget.user.displayName!,
      ),
      accountEmail: Text(
        widget.user.email!,
      ),
      currentAccountPicture: CircleAvatar(
        child: widget.user.photoURL != null
            ? Image(image: NetworkImage(widget.user.photoURL!))
            : Image(image: AssetImage("assets/images/user.png")),
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
                  _isDataLoading = true;
                });
                await MyFirestoreService.mFetchInitialPost(
                        firebaseFirestore: firebaseFirestore,
                        category: "all category")
                    .then((value) {
                  posts!.clear;
                  setState(() {
                    posts = value;
                    _isDataLoading = false;
                  });
                });
              }
            });
          });
        });
  }

  Widget vPostList() {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: posts!.length + 1,
          itemBuilder: ((context, index) {
            return index < posts!.length
                ? vItem(index)
                : MyWidget.vPostPaginationShimmering(context: context);
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.white,
          value: _dropDownValue,
          onChanged: (newValue) async {
            _dropDownValue = newValue!;
            setState(() {
              _isDataLoading = true;
            });
            await MyFirestoreService.mFetchInitialPost(
                    firebaseFirestore: firebaseFirestore,
                    category: _dropDownValue)
                .then((value) {
              posts!.clear;
              setState(() {
                posts = value;
                _isDataLoading = false;
                logger.d("Clicked: $newValue");
              });
            });
          },
          items: [
            'All Category',
            'Drawings',
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

  Widget vCatAndCap(Post post) {
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
                post.category!,
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
            Text(post.caption!),
          ],
        ),
      ],
    );
  }

  Widget vItem(int index) {
    Post post = posts![index];
    return GFCard(
      // color: Colors.white,
      elevation: 5,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      // e: test
      /* image: Image.network(
        post.imgUri!,
        fit: BoxFit.cover,
      ), */
      // e: test
      // showImage: true,
      showImage: false,
      title: GFListTile(
        margin: EdgeInsets.only(bottom: 6),
        shadow: BoxShadow(color: Colors.white),
        color: Colors.white,
        avatar: GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        // e: test
        // titleText: post.users!.username,
        titleText: post.postId,
        subTitleText: mFormatDateTime(post),
      ),
      content: vCatAndCap(post),
      buttonBar: GFButtonBar(
        padding: EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeButton(post),
          vCommentButton(post),
        ],
      ),
    );
  }

  Widget vLikeButton(Post post) {
    return InkWell(
      onTap: () async {
        mOnClickLikeButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: post.likeStatus!
                ? Colors.deepOrange
                : Colors.black12 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.favorite_outline,
              color: post.likeStatus! ? Colors.white : MyColors.secondColor,
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
          post.numOfLikes == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfLikes}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  Widget vCommentButton(Post post) {
    return InkWell(
      onTap: () {
        mOnClickCommentButton(post);
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
          post.numOfComments == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfComments}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  void mOnClickCommentButton(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
        post: post,
      );
    }));
  }

  Widget vHome() {
    return Column(
      children: [
        vCategoryDropdown(),
        SizedBox(
          height: 6,
        ),
        _isDataLoading
            ? MyWidget.vPostShimmering(context: context)
            : posts == null || posts!.isEmpty
                ? vNoResultFound()
                : vPostList(),
      ],
    );
  }

  void mOnClickSignOut() async {
    await MyAuthenticationService.mSignOut(firebaseAuth: _firebaseAuth)
        .then((value) {
      if (value) {
        logger.w("Sign Out");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    });
  }

  void mLoadData() async {
    logger.d("Loading post...");
    MyFirestoreService.mFetchInitialPost(
            firebaseFirestore: firebaseFirestore, category: _imgCategory)
        .then((value) {
      setState(() {
        posts = value;
        /*  int i = posts!
            .indexWhere((element) => element.postId == "C71CC8DQdedbivs0kbXD");
        logger.d("Index is: $i"); */
        _isDataLoading = false;
      });
    });
  }

  String mFormatDateTime(Post post) {
    int currentDate = DateTime.now().day;
    int uploadedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)).day;
/*     MyDateForamt.mFormateDate2(
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!))); */
    const String today = "Today";
    const String yesterday = "Yesterday";

    if (currentDate == uploadedDate) {
      return today;
    } else if (uploadedDate == currentDate - 1) {
      return yesterday;
    } else {
      return MyDateForamt.mFormateDate2(
          DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)));
    }
  }

  void mControlListViewSrolling() {
    // c: add a scroll listener to scrollController
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // c: Reached the end of the ListView
      // c: Perform any actions or load more data
      // c: You can trigger pagination or fetch more items here

      logger.w("End of List");
      mLoadMore();
    }
  }

  void mLoadMore() async {
    await MyFirestoreService.mFetchMorePosts(
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isNotEmpty) {
        /*     List<Post> tempPosts = posts!;
        posts!.clear(); */
        setState(() {
          posts!.addAll(value);
        });
      } else {
        logger.w("No Data exist");
      }
    });
  }

  Future<void> mOnClickLikeButton(Post post) async {
    await MyFirestoreService.mStoreLikeData(
            firebaseFirestore: firebaseFirestore,
            email: post.email!,
            postId: post.postId!)
        .then((like) {
      if (like != null) {
        if (like) {
          // c: like
          logger.w("Like");
          posts![posts!.indexOf(post)].likeStatus = true;
        } else {
          // c: unlike
          logger.w("UnLike");
          posts![posts!.indexOf(post)].likeStatus = false;
        }
        // c: refresh
        setState(() {});
      }
    });
  }

  void mAddCollectionReferencePOSTListener() {
    _collectionReferencePOST.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED new item id: ${docChange.doc.id}");
        } else if (docChange.type == DocumentChangeType.modified) {
          logger.w("MODIFIED Post at ${docChange.doc.id}");
          var modifiedDocId = docChange.doc.id;
          int i =
              posts!.indexWhere((element) => element.postId == modifiedDocId);
          mUpdatePostData(docChange.doc, i);
          setState(() {});
          // logger.d("Index is: $i");
        }
      }
    });
  }

  void mAddCollectionReferenceLIKERListener() {
    _collectionReferenceLIKER.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED one item ${docChange.newIndex}");
        } else if (docChange.type == DocumentChangeType.modified) {
          setState(() {
            logger
                .w("MODIFIED one item ${docChange.doc.get(MyKeywords.email)}");
          });
        } else if (docChange.type == DocumentChangeType.removed) {
          setState(() {
            logger
                .w("REMOVED one item: ${docChange.doc.get(MyKeywords.email)}");
          });
        }
      }
    });
  }

  void mUpdatePostData(DocumentSnapshot<Object?> doc, int i) {
    posts![i].numOfLikes = doc.get(MyKeywords.num_of_likes);
    posts![i].numOfComments = doc.get(MyKeywords.num_of_comments);
  }

  Widget vNoResultFound() {
    return Expanded(
      child: Center(
        child: Text(
          "No result found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
