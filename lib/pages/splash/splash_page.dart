import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/splash/terms_page.dart';
import 'package:project_kotrip/pages/splash/tutorial_page.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

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
    lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  //튜토리얼, 약관동의 분기
  Future<void> handleLoginSuccess(BuildContext context) async {
    final userVm = ref.read(userViewModelProvider.notifier);
    final authVm = ref.read(authViewModelProvider.notifier);

    final currentUser = authVm.state.user;
    if (currentUser == null) {
      showErrorActionSheet(context, '로그인 정보가 없습니다.');
      return;
    }

    // 항상 Firestore에서 최신 유저 정보 로드
    await userVm.loadUser(currentUser.uid);

    final loadedUser = userVm.state.user;
    if (loadedUser == null) {
      showErrorActionSheet(context, '유저 정보를 가져오지 못했습니다.');
      return;
    }

    // 분기 처리
    if (!loadedUser.hasAgreedTerms) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TermsPage()), // 약관동의
      );
    } else if (!loadedUser.hasSeenTutorial) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TutorialPage()), // 튜토리얼
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AppBtNavi(initialIndex: 0)), // 홈
        (route) => false,
      );
    }
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
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    child: AnimatedSlide(
                      offset: showBtn ? Offset(0, 0) : Offset(0, 0.05),
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 15),
                          Text('손쉽게 만드는 나만의 국내여행 일정', style: AppTxtSt.txtStR),
                          SizedBox(height: 100),
                          //구글로 로그인
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() => isLoading = true);
                                final result = await authState.signInWithGoogle();
                                setState(() => isLoading = false);
                                if (result) {
                                  await handleLoginSuccess(context);
                                } else {
                                  showErrorActionSheet(context, '로그인 실패');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(10),
                                    topEnd: Radius.circular(10),
                                  ),
                                ),
                                backgroundColor: colPrimary,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/icon_google.png',
                                    width: 20,
                                  ),
                                  Text(
                                    '구글로 로그인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //애플로 로그인
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() => isLoading = true);
                                final result = await authState.signInWithApple();
                                setState(() => isLoading = false);
                                if (result) {
                                  await handleLoginSuccess(context);
                                } else {
                                  showErrorActionSheet(context, '로그인 실패');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.only(
                                    bottomStart: Radius.circular(10),
                                    bottomEnd: Radius.circular(10),
                                  ),
                                ),
                                backgroundColor: colSecond,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/icon_apple.png',
                                    width: 20,
                                  ),
                                  Text(
                                    '애플로 로그인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          //로그인 없이 시작하기
                          TextButton(
                            onPressed: () async {
                              setState(() => isLoading = true);
                              final result = await authState.signInAnonymously();
                              setState(() => isLoading = false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => TermsPage()),
                              );
                            },
                            child: Text('로그인 없이 시작하기', style: AppTxtSt.hintStR),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) LoadingWidget(message: '로그인중...'),
      ],
    );
  }
}
