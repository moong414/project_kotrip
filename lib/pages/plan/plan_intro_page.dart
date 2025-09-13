import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/Plan_page.dart';
import 'package:project_kotrip/pages/plan/widgets/text_form.dart';

class PlanIntroPage extends StatelessWidget {
  PlanIntroPage({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이번엔 어디로 갈까요?', style: AppTxtSt.titleSt),
          SizedBox(height: 20),
          PlanTextForm(hintText: '지역을 입력하세요', controller: controller),
          SizedBox(height: 20),
          Text('언제 떠나시나요?', style: AppTxtSt.titleSt),
          SizedBox(height: 20),
          PlanTextForm(
            hintText: '시작일을 입력하세요',
            controller: controller,
            isLabel: true,
            labelText: '시작일',
          ),
          SizedBox(height: 10),
          PlanTextForm(
            hintText: '도착일을 입력하세요',
            controller: controller,
            isLabel: true,
            labelText: '도착일',
          ),
          SizedBox(height: 20),
          AppButton(text: '직접 여행 계획 세우기', onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlanPage();
            },));
          }),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colGreenAi, colMintAi]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                //AI에게 부탁하기
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(16, 17, 16, 16),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icon_ai_wt.png', width: 20),
                  SizedBox(width: 6),
                  Text(
                    'AI에게 부탁하기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
