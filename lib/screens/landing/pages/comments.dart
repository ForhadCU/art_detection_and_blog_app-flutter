// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/controller/my_services.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/text_field/gf_text_field.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:logger/logger.dart';

import '../../../models/model.post.dart';

class CommentsPage extends StatefulWidget {
  final Post post;
  const CommentsPage({super.key, required this.post});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _editingControllerComment =
      TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late Post _post;
  List<Commenter>? _comments;
  final ScrollController _scrollController = ScrollController();
  Logger? logger;

  @override
  void initState() {
    super.initState();
    _post = widget.post;

    mLoadData();
    // mControlListViewScrolling();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vAppBar(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: _comments == null
            ? MyWidget.vCommentShimmering(context: context)
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _comments!.isEmpty ? vNoResultFound() : vAllComments(),
                  vInputComment(),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget vAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: MyColors.secondColor),
        // titleTextStyle: TextStyle(color: MyColors.secondColor),
        title: const Text(
          "Comments",
          style: TextStyle(color: MyColors.secondColor),
        ));
  }

  Widget vAllComments() {
    return Expanded(
        child: ListView.builder(
            controller: _scrollController,
            reverse: false,
            itemCount: _comments!.length,
            itemBuilder: (context, index) {
              Commenter commenter = _comments![index];
              return vItem(commenter);
            }));
  }

  Widget vItem(Commenter commenter) {
    return Column(
      children: [
        GFListTile(
          shadow: BoxShadow(color: Colors.white),
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          color: Colors.white,
          avatar: GFAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
              size: 20,
              shape: GFAvatarShape.circle),
          titleText: commenter.user!.username,
        ),
        Container(
          margin: EdgeInsets.only(top: 2, left: 4),
          child: GFCard(
            borderRadius: BorderRadius.circular(2),
            elevation: 0,
            color: MyColors.fourthColor,
            content: Text(commenter.text!),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.black26,
          height: 1,
        )
      ],
    );
  }

  Widget vInputComment() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: GFTextField(
        controller: _editingControllerComment,
        maxLines: 2,
        maxLength: 200,
        decoration: InputDecoration(
            hintText: "Write a comment",
            suffixIcon: IconButton(
              onPressed: () {
                mOnClickSendComment();
              },
              icon: Icon(Icons.send),
              color: Colors.black45,
            )),
        /* decoration: InputDecoration(border: OutlineInputBorder()) */
      ),
    );
  }

  void mOnClickSendComment() async {
    if (_editingControllerComment.value.text.isNotEmpty) {
      String comment = _editingControllerComment.value.text.trim();
      Commenter commenter = Commenter(
          email: _post.email!,
          text: comment,
          ts: DateTime.now().millisecondsSinceEpoch.toString());
      await MyFirestoreService.mStoreCommentData(
        firebaseFirestore: _firebaseFirestore,
        postId: _post.postId!,
        commenter: commenter,
      ).then((value) async {
        if (value) {
          // c: clear comment box
          _editingControllerComment.clear();
          // c: add current user's data to commenter object
          commenter.user = _post.users;
          // c: add new commenter object into comments list
          _comments!.add(commenter);
// refresh
          setState(() {});

          await Future.delayed(Duration(milliseconds: 1000));
          // c: comments list view scrolled to up
          mScrollDown();
        }
      });
    }
  }

  void mLoadData() async {
    MyFirestoreService.mFetchAllComments(
            firebaseFirestore: _firebaseFirestore, postId: _post.postId!)
        .then((comments) {
      setState(() {
        _comments = comments;
      });
    });
  }

  Widget vNoResultFound() {
    return Expanded(
      child: Center(
        child: Text(
          "No comment found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void mControlListViewScrolling() {
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {}

  // Scroll down on button click
  void mScrollDown() {
    _scrollController.animateTo(
      /* double.parse(_comments!.length.toString()) */
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

// Scroll up on button click
  void mScrollUp() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
