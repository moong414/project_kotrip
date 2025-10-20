import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/my/my_plan_detail_view_page.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPlanLink extends ConsumerWidget {
  const MyPlanLink({super.key, required this.myPlans, required this.authState});
  final PlanState myPlans;
  final AuthState authState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planFunc = ref.read(planViewModelProvider.notifier);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final startDate = DateTime(myPlans.startDate.year, myPlans.startDate.month, myPlans.startDate.day);
    final dday = startDate.difference(todayDate).inDays;

    return GestureDetector(
      onLongPress: () async {
        final result = await showConfirmDialog(context, '계획을 삭제하시겠습니까?');
        if (result == true) {
          if (authState.user == null) {
            showErrorActionSheet(context, '로그인이 필요합니다.');
            return;
          }

          if (myPlans.planId == null) {
            planFunc.planClear();
          } else {
            await planFunc.deletePlan(authState.user!.uid, myPlans.planId!);
          }
        }
      },
      onTap: () async {
        if (authState.user != null && myPlans.planId != null) {
          await planFunc.getPlanById(authState.user!.uid, myPlans.planId!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MyPlanDetailViewPage();
              },
            ),
          );
        } else {
          showErrorActionSheet(context, '정보가 올바르지 않습니다.');
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colGreyBtn),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          myPlans.area,
                          style: AppTxtSt.txtStL,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 5),
                      if (dday >= 0)
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 1),
                          decoration: BoxDecoration(
                            color: dday == 0 ? colPrimary : colHintTxt,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            dday == 0 ? 'D-Day' : 'D-$dday',
                            style: AppTxtSt.txtStS.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    '${myPlans.startFormat} - ${myPlans.endFormat}',
                    style: AppTxtSt.txtStR,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Image.asset('assets/images/icon_go_arrow.png', width: 24),
          ],
        ),
      ),
    );
  }
}
