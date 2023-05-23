// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/my_screensize.dart';

import '../../utils/my_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget textfield({@required hintText}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /* appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff555555),
        
      ), */
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                vProfileImage(MyScreenSize.mGetWidth( context, 32), MyScreenSize.mGetHeight(context, 24),),
                /* Positioned(
                  bottom: 28,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ), */
              ],
            ),

            /*   CustomPaint(
              painter: HeaderCurvedContainer(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ), */
          ],
        ),
      ),
    );
  }

  Widget vProfileImage(double height, double width) {
    return Container(
      width:height ,
      height: width,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.fourthColor, width: 5),
        shape: BoxShape.circle,
        color: MyColors.fourthColor,
        image: const DecorationImage(
            fit: BoxFit.contain,
            // image: AssetImage('images/profile.png'),
            image: AssetImage("assets/images/user.png")),
      ),
    );
  }

  // Widget 
}

/* class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColors.thirdColor;
    Path path = Path()
      ..relativeLineTo(0, 50)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 50)
      ..relativeLineTo(0, -50)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */
