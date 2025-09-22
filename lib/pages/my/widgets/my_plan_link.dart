import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/show_error_action_sheet.dart';
import 'package:project_kotrip/pages/plan/plan_finish_page.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPlanLink extends ConsumerWidget {
  const MyPlanLink({super.key, required this.myPlans, required this.authState});
  final PlanState myPlans;
  final AuthState authState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planViewModelProvider.notifier);

    return GestureDetector(
      onTap: () async {
        if (authState.user != null && myPlans.planId != null) {
          await planState.getPlanById(authState.user!.uid, myPlans.planId!);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PlanFinishPage()),);
        } else {
          showErrorActionSheet(context, '정보가 올바르지 않습니다.');
        }
        print('authState ${authState}, myPlans id ${myPlans.planId}, user ${authState.user}========================================');
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: BoxBorder.all(color: colGreyBtn),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(myPlans.area, style: AppTxtSt.txtStL),
                SizedBox(height: 4),
                Text(
                  '${DateFormat('yy.MM.dd').format(myPlans.startDate)} - ${DateFormat('yy.MM.dd').format(myPlans.endDate)}',
                  style: AppTxtSt.txtStR,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset('assets/images/icon_go_arrow.png', width: 24),
            ),
          ],
        ),
      ),
    );
  }
}
