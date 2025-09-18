import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_oneday_list.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_dialog.dart';

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planViewModelProvider);
    //총여행 날짜 구하기
    final totalDays = planState.endDate.difference(planState.startDate).inDays + 1;
    

    return Scaffold(
      appBar: BasicAppBar(),
      floatingActionButton: PlanDialog(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                children: [
                  Text(planState.area, style: AppTxtSt.titleStB),
                  SizedBox(width: 8),
                  Text(
                    '${DateFormat('yy.MM.dd').format(planState.startDate)} - ${DateFormat('yy.MM.dd').format(planState.endDate)}',
                    style: AppTxtSt.txtStL,
                  ),
                ],
              ),
              //1일 계획 목록
              Expanded(
                child: PageView.builder(
                  itemCount: totalDays,
                  itemBuilder: (context, index) {
                    return PlanOnedayList(planState: planState, index: index, totalDays: totalDays);
                },),
              ),
              Container(
                height: 72,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        bgColor: colGreyBtn,
                        txtColor: colBkTxt,
                        text: '취소',
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        bgColor: colBkBtn,
                        text: '저장',
                        onPressed: () {},
                      ),
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
