import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/plan_ai_page.dart';
import 'package:project_kotrip/pages/plan/plan_page.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/intro_date_widget.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_text_form.dart';

class PlanIntroPage extends ConsumerStatefulWidget {
  String? title;
  PlanIntroPage({super.key, this.title});

  @override
  ConsumerState<PlanIntroPage> createState() => _PlanIntroPageState();
}

class _PlanIntroPageState extends ConsumerState<PlanIntroPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController regionController;

  @override
  void initState() {
    super.initState();
    regionController = TextEditingController(text: widget.title ?? '');
  }

  @override
  void dispose() {
    regionController.dispose();
    super.dispose();
  }

  //검증
  void onTapNextBtn(Widget widget) {
    if (formKey.currentState!.validate()) {
      //페이지 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.read(planViewModelProvider.notifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이번엔 어디로 갈까요?', style: AppTxtSt.titleSt),
                SizedBox(height: 20),
                PlanTextForm(hintText: '지역을 입력하세요', controller: regionController),
                SizedBox(height: 20),
                Text('언제 떠나시나요?', style: AppTxtSt.titleSt),
                SizedBox(height: 20),
                IntroDateWidget(hintText: '시작일을 입력하세요', labelText: '시작일'),
                SizedBox(height: 10),
                IntroDateWidget(hintText: '도착일을 입력하세요', labelText: '도착일', isStartDate: false,),
                SizedBox(height: 20),
                //직접여행계획세우기 버튼
                AppButton(
                  text: '직접 여행 계획 세우기',
                  onPressed: () {
                    //뷰모델에 전달
                    planState.updatePlace(regionController.text);
                    onTapNextBtn(PlanPage());
                  },
                ),
                SizedBox(height: 10),
                //AI에게 부탁하기 버튼
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colGreenAi, colMintAi]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      //뷰모델에 전달
                      planState.updatePlace(regionController.text);
                      //AI에게 부탁하기
                      onTapNextBtn(PlanAiPage());
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.fromLTRB(16, 17, 16, 16),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/icon_ai_wt.png', width: 20),
                        SizedBox(width: 6),
                        Text('AI에게 부탁하기', style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }
}
