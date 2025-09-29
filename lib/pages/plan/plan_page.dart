import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/plan/plan_finish_page.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_oneday_list.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_dialog_btn.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_top_info.dart';

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  final PageController pageController = PageController(initialPage: 0);
  int thisPage = 0; //지금 몇페이지인지 확인용

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planViewModelProvider);
    //총여행날짜
    final totalDays = planState.endDate.difference(planState.startDate).inDays + 1;
    //페이지별 날짜 표시
    final pageDate = DateFormat('yy.MM.dd').format(planState.startDate.add(Duration(days: thisPage)));

    //페이지 이동
    void nextPage() {
      if (thisPage < totalDays) {
        pageController.animateToPage(
          thisPage + 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          thisPage += 1;
        });
      }
    }
    void prevPage() {
      if (thisPage > 0) {
        pageController.animateToPage(
          thisPage - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          thisPage -= 1;
        });
      }
    }

    return Scaffold(
      appBar: BasicAppBar(),
      floatingActionButton: PlanDialogBtn(thisPage: thisPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              //상단정보
              PlanTopInfo(planState: planState, startDate: planState.startFormat, endDate: planState.endFormat),
              //상단 날짜 & 페이지 이동 컨트롤러
              Container(
                height: 56,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: colGreyBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (thisPage > 0 && totalDays != 0)
                        ? GestureDetector(
                            onTap: prevPage,
                            child: Container(
                              width: 56,
                              height: 56,
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Image.asset('assets/images/icon_back.png'),
                            ),
                          )
                        : SizedBox(width: 56, height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Day ${thisPage + 1} ', style: AppTxtSt.txtStLB),
                        Text(pageDate, style: AppTxtSt.txtStR),
                      ],
                    ),
                    (thisPage < totalDays && thisPage != totalDays - 1)
                        ? GestureDetector(
                            onTap: nextPage,
                            child: Container(
                              width: 56,
                              height: 56,
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/images/icon_go_arrow.png',
                              ),
                            ),
                          )
                        : SizedBox(width: 56, height: 56),
                  ],
                ),
              ),
              //1일 계획 목록
              SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: totalDays,
                  itemBuilder: (context, index) {
                    return PlanOnedayList(today: index, totalDays: totalDays);
                  },
                  onPageChanged: (index) {
                    setState(() {
                      thisPage = index;
                    });
                  },
                ),
              ),
              //하단취소저장버튼
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
                        onPressed: () async {
                          final result = await showConfirmDialog(
                            context,
                            '계획을 취소하시겠습니까?',
                          );
                          if (result == true) {
                            ref.read(planViewModelProvider.notifier).planClear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AppBtNavi(initialIndex: 1);
                                },
                              ),(route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        bgColor: colBkBtn,
                        text: '확인',
                        onPressed: () {
                          bool hasPlan = planState.planList.any((day) => day.isNotEmpty);
                          if(!hasPlan){
                            showErrorActionSheet(context, '일정을 추가해주세요.');
                            print('planState.planList ${planState.planList}');
                            return;
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PlanFinishPage();
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

