import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/my/widgets/my_plan_link.dart';
import 'package:project_kotrip/pages/my/widgets/my_review_link.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colGrBg,
          ),
          child: Row(
            children: [
              Text('안녕하세요!', style: AppTxtSt.txtStL),
              Text('김땡땡', style: AppTxtSt.txtStLB),
              Text('님', style: AppTxtSt.txtStL),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(top: 20, bottom: 10),
          child: Text('내 여행 계획 보기', style: AppTxtSt.titleSt),
        ),
        MyPlanLink(),
        MyPlanLink(),
        MyPlanLink(),
        Padding(
          padding: EdgeInsetsGeometry.only(top: 20, bottom: 10),
          child: Text('내 여행 계획 보기', style: AppTxtSt.titleSt),
        ),
        MyReviewLink(),
        MyReviewLink(),
        MyReviewLink(),
        GestureDetector(
          onTap: () {
            //탈퇴
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            color: Colors.transparent,
            child: Text('탈퇴하기', textAlign: TextAlign.end),
          ),
        ),
      ],
    );
  }
}
