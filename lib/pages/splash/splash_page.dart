import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/pages/splash/widget/splash_btn.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double aniOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        aniOpacity = 1.0;
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: AnimatedOpacity(
              opacity: aniOpacity,
              duration: Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              
                children: [
                  Image.asset('assets/images/logo.png', height: 45),
                  SizedBox(height: 15),
                  Text(
                    '손쉽게 만드는 나만의 국내여행 일정',
                    style: TextStyle(
                      color: colBkTxt,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 120),
                  SplashBtn(imgSrc: 'assets/images/icon_google.png', title: '구글로 로그인',),
                  SplashBtn(imgSrc: 'assets/images/icon_apple.png', title: '애플로 로그인', bgColor: colSecond, upSideDown: true,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
