import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/data/model/plan_model.dart';

class PlanState {
  String area;
  DateTime startDate;
  DateTime endDate;
  List<List<PlanModel>> planList; // 날짜별 할일 리스트

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
    List<DateTime>? dateList,
    List<List<PlanModel>>? planLists,
  }) {
    return PlanState(
      area: area ?? this.area,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      planList: planLists ?? this.planList,
    );
  }
}

class PlanViewModel extends Notifier<PlanState> {
  @override
  PlanState build() {
    return PlanState(
      area: '',
      startDate: DateTime(1970, 1, 1),
      endDate: DateTime(1970, 1, 1),
      planList: [],
    );
  }

  // 장소 업데이트
  void updatePlace(String text) {
    state = state.copyWith(area: text);
  }

  //출발 날짜
  void updateStartDate(DateTime date) {
    state = state.copyWith(startDate: date);

    if(state.endDate != DateTime(1970, 1, 1)){
      final days = state.endDate.difference(state.startDate).inDays + 1;
      while (state.planList.length < days) {
        state.planList.add([]);
      }
    }
  }

  //도착 날짜 
  void updateEndDate(DateTime date) {
    state = state.copyWith(endDate: date);

    if(state.startDate != DateTime(1970, 1, 1)){
      final days = state.endDate.difference(state.startDate).inDays + 1;
      while (state.planList.length < days) {
        state.planList.add([]);
      }
    }
  }


  //할일추가
  void addTodo(int dateIndex, PlanModel todo) {
    final newPlanList = List<List<PlanModel>>.from(state.planList);
    newPlanList[dateIndex] = [...newPlanList[dateIndex], todo];
    state = state.copyWith(planLists: newPlanList);
  }

}

final planViewModelProvider =
    NotifierProvider<PlanViewModel, PlanState>(() => PlanViewModel());
