import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/finish_item_widget.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_top_info.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyPlanDetailViewPage extends ConsumerStatefulWidget {
  const MyPlanDetailViewPage({super.key});

  @override
  ConsumerState<MyPlanDetailViewPage> createState() => _MyPlanDetailPageState();
}

class _MyPlanDetailPageState extends ConsumerState<MyPlanDetailViewPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  int? btnIndex = 0; //스크롤버튼용

  // 클릭시 날짜로 이동
  void scrollToPlan(int index) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planViewModelProvider);
    final planFunc = ref.read(planViewModelProvider.notifier);
    final authState = ref.read(authViewModelProvider);

    return Scaffold(
      appBar: BasicAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await showConfirmDialog(context, '계획을 삭제하시겠습니까?',);
          if (result == true) {
            if (planState.planId == null) {
              planFunc.planClear();
            } else {
              await planFunc.deletePlan(authState.user!.uid, planState.planId!);
              // MyPlanViewModel 갱신
              await ref.read(myPlanViewModelProvider.notifier).loadPlanList(authState.user!.uid);
            }
            Navigator.pop(context);
          }
          
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Image.asset('assets/images/icon_delete_wt.png', width: 24,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              //상단정보
              PlanTopInfo(
                planState: planState,
                startDate: planState.startFormat,
                endDate: planState.endFormat,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: planState.planList.length,
                  itemBuilder: (context, index) {
                    final tabBtn = btnIndex == index;
                    return GestureDetector(
                      onTap: () {
                        //클릭시 이동
                        scrollToPlan(index);
                        setState(() {
                          if (!tabBtn) {
                            btnIndex = index;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: tabBtn ? colPrimary : colGreyBg,
                        ),
                        child: Center(
                          child: Text(
                            'Day ${index + 1}',
                            style: AppTxtSt.txtStL.copyWith(
                              color: tabBtn ? Colors.white : colBkTxt,
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
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
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
            ],
          ),
        ),
      ),
    );
  }
}
