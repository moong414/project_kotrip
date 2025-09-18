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

  PlanState copyWith({
    String? area,
    DateTime? startDate,
    DateTime? endDate,
    List<PlanModel>? planList,
  }) {
    return PlanState(
      area: area ?? this.area,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      planList: planList ?? this.planList,
    );
  }
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

  //장소업데이트
  void updatePlace(String text) {
    state = state.copyWith(area: text);
  }
  //날짜업데이트
  void updateStartDate(DateTime date){
    state = state.copyWith(startDate: date);
  }
  void updateEndDate(DateTime date){
    state = state.copyWith(endDate: date);
  }
}

final planViewModelProvider = NotifierProvider<PlanViewModel, PlanState>(() {
  return PlanViewModel();
});
