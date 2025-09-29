import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';

class SplashBtn extends StatelessWidget {
  String imgSrc;
  String title;
  Color? bgColor;
  bool upSideDown;
  Future<bool> Function() loginFunc;

  SplashBtn({
    super.key,
    required this.imgSrc,
    required this.title,
    this.bgColor,
    this.upSideDown = false,
    required this.loginFunc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          final result = await loginFunc();
          if (result) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AppBtNavi(initialIndex: 0);
                },
              ),
              (route) => false,
            );
          } else {
            showErrorActionSheet(context, '로그인 실패');
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: upSideDown
                ? BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10),
                    bottomEnd: Radius.circular(10),
                  )
                : BorderRadiusDirectional.only(
                    topStart: Radius.circular(10),
                    topEnd: Radius.circular(10),
                  ),
          ),
          backgroundColor: bgColor ?? colPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(imgSrc, width: 20),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
