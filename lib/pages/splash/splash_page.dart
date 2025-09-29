import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';
import 'package:project_kotrip/pages/splash/widget/splash_btn.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  bool isLoading = false;
  bool showBtn = false;
  late final AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    lottieController =  AnimationController(vsync: this);
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 140,
                  // height: 45,
                  child: Lottie.asset(
                        'assets/lottie/logo_animation.json',
                        controller: lottieController,
                        onLoaded: (composition) {
                          lottieController
                            ..duration = composition.duration
                            ..forward().whenComplete(() {
                              setState(() => showBtn = true);
                            });
                        },
                      ),
                ),
                AnimatedOpacity(
                  opacity: showBtn ? 1 : 0,
                  duration: Duration(seconds: 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image.asset('assets/images/logo.png', height: 45),
                      SizedBox(height: 15),
                      Text(
                        '손쉽게 만드는 나만의 국내여행 일정',
                        style: AppTxtSt.txtStR
                      ),
                      SizedBox(height: 100),
                      SplashBtn(
                        imgSrc: 'assets/images/icon_google.png',
                        title: '구글로 로그인',
                        loginFunc: authState.signInWithGoogle,
                      ),
                      SplashBtn(
                        imgSrc: 'assets/images/icon_apple.png',
                        title: '애플로 로그인',
                        bgColor: colSecond,
                        upSideDown: true,
                        loginFunc: authState.signInWithApple,
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await authState.signInAnonymously();
                          setState(() {
                            isLoading = false;
                          });
                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AppBtNavi(initialIndex: 0);
                                },
                              ),(route) => false,
                            );
                          } else {
                            showErrorActionSheet(context, '로그인 실패');
                          }
                        },
                        child: Text('로그인 없이 시작하기', style: AppTxtSt.hintStR),
                      ),
                    ],
                  ),
                ),
              ],),
            ),
          ),
        ),
        if (isLoading) LoadingWidget(message: '로그인중...'),
      ],
    );
  }
}
