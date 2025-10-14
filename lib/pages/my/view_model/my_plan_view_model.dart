import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/plan/data/fire_plan_repository.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

//내 모든 계획 관리
class PlanListState {
  final List<PlanState> pastPlans;
  final List<PlanState> plans;

  PlanListState({
    required this.pastPlans,
    required this.plans,
  });
}


class MyPlanViewModel extends Notifier<PlanListState> {
  final FirePlanRepository repo = FirePlanRepository();

  @override
  PlanListState build() => PlanListState(pastPlans: [], plans: []);

  //firebase에서 해당 유저 계획 가져오기
  Future<void> loadPlanList(String userId) async {
    final plans = await repo.getPlan(userId);
    final now = DateTime.now();

    //날짜별 목록 분리
    final past = plans.where((p) => p.endDate.isBefore(DateTime(now.year, now.month, now.day))).toList();
    final upcoming = plans.where((p) => !p.endDate.isBefore(DateTime(now.year, now.month, now.day))).toList();

    state = PlanListState(
      pastPlans: past,
      plans: upcoming,
    );
  }

  //로그아웃시 계획 
  void clearPlanList() {
    state = PlanListState(pastPlans: [], plans: []);
  }
}


final myPlanViewModelProvider = NotifierProvider<MyPlanViewModel, PlanListState>(
  () => MyPlanViewModel(),
);
