import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController pageController = PageController();
  int currentPage = 0;

  //상단페이지이동네비버튼
  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //페이지이동
  void onNextPressed() {
    if (currentPage < 2) {
      goToPage(currentPage + 1);
    } else {
      //홈으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AppBtNavi(initialIndex: 0)), // 홈
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnchorButton(
                    selected: currentPage == 0,
                    onTap: () => goToPage(0),
                  ),
                  AnchorButton(
                    selected: currentPage == 1,
                    onTap: () => goToPage(1),
                  ),
                  AnchorButton(
                    selected: currentPage == 2,
                    onTap: () => goToPage(2),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: [
                    TutorialSection(
                      title: '이번엔 어디로 갈까요?',
                      txt: '직접 여행을 계획하거나\nAI에게 부탁할수도 있어요!',
                      img: 'assets/images/img_tu01.png',
                      btnTxt: '다음',
                      onNext: onNextPressed,
                    ),
                    TutorialSection(
                      title: '이런곳은 어떨까요?',
                      txt: '전국의 관광지, 문화시설, 음식, 쇼핑\n정보를 볼 수 있어요!',
                      img: 'assets/images/img_tu02.png',
                      btnTxt: '다음',
                      onNext: onNextPressed,
                    ),
                    TutorialSection(
                      title: '내 장소의 날씨를 확인하세요!',
                      txt: '마이페이지에서 내 장소나 여행지의 장소를 등록하고\n실시간 날씨를 확인하세요!',
                      img: 'assets/images/img_tu03.png',
                      btnTxt: '시작하기',
                      onNext: onNextPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnchorButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const AnchorButton({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? colPrimary : colHintTxt,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialSection extends StatelessWidget {
  final String title;
  final String txt;
  final String img;
  final String btnTxt;
  final VoidCallback onNext;

  const TutorialSection({
    super.key,
    required this.title,
    required this.txt,
    required this.img,
    required this.btnTxt,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(title, style: AppTxtSt.titleStL),
            const SizedBox(height: 20),
            Text(txt, style: AppTxtSt.txtStR, textAlign: TextAlign.center),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(img, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(
                  backgroundColor: colPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  btnTxt,
                  style: AppTxtSt.txtStL.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
