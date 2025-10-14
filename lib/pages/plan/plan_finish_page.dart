import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/finish_item_widget.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_top_info.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class PlanFinishPage extends ConsumerStatefulWidget {
  const PlanFinishPage({super.key});

  @override
  ConsumerState<PlanFinishPage> createState() => _PlanFinishPageState();
}

class _PlanFinishPageState extends ConsumerState<PlanFinishPage> {
  bool isLoading = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  int? btnIndex = 0;  //스크롤버튼용

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planViewModelProvider);
    final planFunc = ref.read(planViewModelProvider.notifier);
    final authState = ref.read(authViewModelProvider); //로그인상태
    final myPlans = ref.read(myPlanViewModelProvider.notifier);
    
    return Stack(
      children: [
        Scaffold(
          appBar: BasicAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                //상단정보
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: PlanTopInfo(
                    planState: planState,
                    startDate: planState.startFormat,
                    endDate: planState.endFormat,
                  ),
                ),
                (planState.planList.length > 1)
                ? Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: planState.planList.length,
                    itemBuilder: (context, index) {
                      final tabBtn = btnIndex == index;
                      return GestureDetector(
                        onTap: () {
                          //클릭시 이동
                          scrollToPlan(index);
                          setState(() {
                            if(!tabBtn){
                              btnIndex = index;
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
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
                  ),
                )
                : SizedBox(height: 20,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemCount: planState.planList.length,
                      itemBuilder: (context, dayIndex) {
                        //페이지별 날짜
                        final pageDate = DateFormat('yy.MM.dd').format(planState.startDate.add(Duration(days: dayIndex)),);
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
                ),
                Container(
                  height: 72,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              if (planState.planId == null) {
                                planFunc.planClear();
                                print('고냥 삭제');
                              } else {
                                planFunc.deletePlan(
                                  authState.user!.uid,
                                  planState.planId!,
                                );
                              }
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AppBtNavi(initialIndex: 0);
                                  },
                                ),
                                (route) => false,
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
                            setState(() {
                              isLoading = true;
                            });
                            final result = await showConfirmDialog(
                              context,
                              '저장되었습니다.\n마이페이지에서 확인 하실수있습니다.',
                              justConfirm: false,
                            );
                            setState(() {
                              isLoading = false; // 로딩 끝
                            });
                            if (result == true) {
                              //파이어베이스 저장
                              await planFunc.savePlan(authState.user!.uid);
                              //파이어베이스의 플랜리스트 '내 모든 계획 관리'갱신
                              await myPlans.loadPlanList(authState.user!.uid);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AppBtNavi(initialIndex: 0);
                                  },
                                ),(route) => false,
                              );
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
        if (isLoading) LoadingWidget(message: '저장하는중...'),
      ],
    );
  }
}
