import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/plan/data/fire_plan_repository.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

//내 모든 계획 관리
class PlanListState {
  List<PlanState> plans;
  PlanListState({required this.plans});
}

class MyPlanViewModel extends Notifier<PlanListState> {
  final FirePlanRepository repo = FirePlanRepository();

  @override
  PlanListState build() => PlanListState(plans: []);

  Future<void> loadPlanList(String userId) async {
    final plans = await repo.getPlan(userId);
    state = PlanListState(plans: plans);
  }

}

final myPlanViewModelProvider = NotifierProvider<MyPlanViewModel, PlanListState>(
  () => MyPlanViewModel(),
);
