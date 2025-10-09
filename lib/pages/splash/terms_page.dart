import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/splash/tutorial_page.dart';

class TermsPage extends ConsumerStatefulWidget {
  const TermsPage({super.key});

  @override
  ConsumerState<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends ConsumerState<TermsPage> {
  bool isLoading = false;
  bool allAgree = false;
  bool serviceAgree = false;
  bool privacyAgree = false;

  //다음페이지로 넘어갈수있는지 여부
  bool get canPassPage => serviceAgree && privacyAgree;

  //모두동의
  void toggleAllAgree() {
    setState(() {
      allAgree = !allAgree;
      serviceAgree = allAgree;
      privacyAgree = allAgree;
    });
  }

  //동의버튼
  void toggleAgree(String type) {
  setState(() {
    if (type == 'service') {
      serviceAgree = !serviceAgree;
    } else if (type == 'privacy') {
      privacyAgree = !privacyAgree;
    }
    allAgree = serviceAgree && privacyAgree;
  });
}

  Future<void> onConfirmPressed() async {
    
    if (!canPassPage) {
      showErrorActionSheet(context, '모든 필수 약관에 동의해야 합니다.');
      return;
    }
    setState(() => isLoading = true);
    final userVm = ref.read(userViewModelProvider.notifier);
    await userVm.updateAgreedTerms(true);
    // 0.5초 딜레이
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TutorialPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 70),
                        Image.asset('assets/images/logo.png', width: 100),
                        SizedBox(height: 18),
                        Text('Kotrip에 오신것을 환영합니다!', style: AppTxtSt.titleSt),
                        SizedBox(height: 18),
                        Text(
                          '서비스 가입을 위해\n이용약관 및 정보제공에 동의해주세요.',
                          style: AppTxtSt.hintStR,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: toggleAllAgree,
                        style: TextButton.styleFrom(
                          backgroundColor: colGreyBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: colGreyBtn),
                          ),
                          minimumSize: Size(double.infinity, 56),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('필수 약관에 모두 동의합니다.', style: AppTxtSt.txtStL),
                              Image.asset(
                                allAgree
                                    ? 'assets/images/icon_check_on.png'
                                    : 'assets/images/icon_check.png',
                                width: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      AgreeBox(
                        title: '서비스 이용약관',
                        txt:
                            '1. 회원 계정은 본인만 사용해야 하며, 타인에게 양도할 수 없습니다.\n2. 앱 내 제공되는 콘텐츠는 저작권법 등 관련 법령을 준수해야 합니다.\n3. 부적절한 게시물, 불법 행위, 서비스 방해 행위는금지됩니다.\n4. 서비스는 사전 공지 없이 변경, 중단될 수 있습니다.',
                        isChecked: serviceAgree,
                        onTap: () => toggleAgree('service'),
                      ),
                      SizedBox(height: 10),
                      AgreeBox(
                        title: '개인정보 처리방침',
                        txt:
                            '수집하는 정보: 이메일, 이름, 로그인 ID, 위치 정보, 서비스이용 기록\n이용 목적: 회원 관리, 맞춤 서비스 제공, 통계 분석보관 기간: 탈퇴 시 즉시 삭제(법적 의무가 있을 경우 별도보관)\n제3자 제공: 법령에 따른 경우 외에는 제공하지 않습니다.',
                        isChecked: privacyAgree,
                        onTap: () => toggleAgree('privacy'),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          '본 서비스는 관련 법령을 준수하여 운영됩니다.',
                          style: AppTxtSt.txtStR,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: onConfirmPressed,
                        style: TextButton.styleFrom(
                          backgroundColor: colPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 56),
                        ),
                        child: Text(
                          '확인',
                          style: AppTxtSt.txtStL.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) LoadingWidget(),
      ],
    );
  }
}

class AgreeBox extends StatelessWidget {
  final String title;
  final String txt;
  final bool isChecked;
  final VoidCallback onTap;

  const AgreeBox({
    super.key,
    required this.title,
    required this.txt,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              side: BorderSide(color: colGreyBtn),
            ),
            minimumSize: Size(double.infinity, 56),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('[필수] ', style: AppTxtSt.txtPrimary),
                    Text(title, style: AppTxtSt.txtStL),
                  ],
                ),
                Image.asset(
                  isChecked
                      ? 'assets/images/icon_check_on.png'
                      : 'assets/images/icon_check.png',
                  width: 24,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            border: Border(
              left: BorderSide(color: colGreyBtn),
              bottom: BorderSide(color: colGreyBtn),
              right: BorderSide(color: colGreyBtn),
            ),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  txt,
                  style: AppTxtSt.hintStR,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
