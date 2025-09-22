import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/finish_item_widget.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_top_info.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class PlanFinishPage extends ConsumerStatefulWidget {
  const PlanFinishPage({super.key});

  @override
  ConsumerState<PlanFinishPage> createState() => _PlanFinishPageState();
}

class _PlanFinishPageState extends ConsumerState<PlanFinishPage> {
  @override
  Widget build(BuildContext context) {
    final planState = ref.read(planViewModelProvider);
    final planStateFunc = ref.read(planViewModelProvider.notifier);
    //출발날짜
    final startDate = DateFormat('yy.MM.dd').format(planState.startDate);
    //도착날짜
    final endDate = DateFormat('yy.MM.dd').format(planState.endDate);
    //로그인상태
    final authState = ref.read(authViewModelProvider);

    return Scaffold(
      appBar: BasicAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              //상단정보
              PlanTopInfo(
                planState: planState,
                startDate: startDate,
                endDate: endDate,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: planState.planList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colPrimary,
                        ),
                        child: Center(
                          child: Text(
                            'Day ${index + 1}',
                            style: AppTxtSt.txtStL.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: planState.planList.length,
                  itemBuilder: (context, dayIndex) {
                    //페이지별 날짜
                    final pageDate = DateFormat(
                      'yy.MM.dd',
                    ).format(planState.startDate.add(Duration(days: dayIndex)));
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                'Day ${dayIndex + 1}',
                                style: AppTxtSt.txtStLB,
                              ),
                              SizedBox(width: 4),
                              Text('($pageDate)'),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: planState.planList[dayIndex].length,
                          itemBuilder: (context, itemIndex) {
                            return FinishItemWidget(
                              index: itemIndex,
                              listLen: planState.planList[dayIndex].length,
                              item: planState.planList[dayIndex][itemIndex],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 72,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        bgColor: colRedBtn,
                        text: '삭제',
                        onPressed: () async {
                          final result = await showConfirmDialog(
                            context,
                            '계획을 삭제하시겠습니까?',
                          );
                          if (result == true) {
                            planStateFunc.planClear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AppBtNavi(initialIndex: 1);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        bgColor: colBkBtn,
                        text: '저장',
                        onPressed: () async {
                          final result = await showConfirmDialog(context, '저장되었습니다.\n마이페이지에서 확인 하실수있습니다.', justConfirm: false, );
                          if (result == true) {
                            planStateFunc.savePlanFirestore(userId: authState.user!.uid);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AppBtNavi(initialIndex: 0,);
                            },));
                          }
                        },
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
