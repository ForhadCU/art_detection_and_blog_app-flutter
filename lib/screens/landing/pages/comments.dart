// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/my_services.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/text_field/gf_text_field.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _editingControllerComment =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: vAppBar(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            vAllComments(),
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
            itemCount: 10,
            itemBuilder: (context, index) {
              return vItem();
            }));
  }

  Widget vItem() {
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
          titleText: "username",
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: GFCard(
            borderRadius: BorderRadius.circular(8),
            elevation: 0,
            color: MyColors.fourthColor,
            content: Text("This is comment, This is comment, his is comment,"
                "This is comment, his is comment, This is comment, "),
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

  void mOnClickSendComment() {
    // e: Add comment
    if (_editingControllerComment.value.text.isNotEmpty) {
      String comment = _editingControllerComment.value.text;

      logger.d(comment);
    }
  }
}
