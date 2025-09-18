import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/data/model/plan_model.dart';

class PlanState {
  String area;
  DateTime startDate;
  DateTime endDate;
  List<PlanModel> planList;

  PlanState({
    required this.area,
    required this.startDate,
    required this.endDate,
    required this.planList,
  });
}

class PlanViewModel extends Notifier<PlanState> {
  @override
  PlanState build() {
    return PlanState(
      area: '',
      startDate: DateTime(00),
      endDate: DateTime(00),
      planList: [],
    );
  }
}

final planViewModelProvider = NotifierProvider<PlanViewModel, PlanState>(() {
  return PlanViewModel();
});
