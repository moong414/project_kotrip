
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';

class SplashBtn extends StatelessWidget {
  String imgSrc;
  String title;
  Color? bgColor;
  bool upSideDown;
  
  SplashBtn({
    super.key,
    required this.imgSrc,
    required this.title,
    this.bgColor,
    this.upSideDown = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: 
            upSideDown ?
            BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              bottomEnd: Radius.circular(10),
            )
            :BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            )
          ),
          backgroundColor: bgColor ??colPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(imgSrc, width: 20,),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
