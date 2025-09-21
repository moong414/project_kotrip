import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/plan/data/plan_model.dart';
import 'package:project_kotrip/pages/plan/data/fire_plan_repository.dart';
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'startDate': startDate,
      'endDate': endDate,
      //중첩된리스트는 파이어스토어에서 지원하지않아서 문자열로 바꿔서 저장하기
      'planList': jsonEncode(
        planList.map((list) => list.map((plan) => plan.toMap()).toList()).toList(),
      ),
    };
  }

  factory PlanState.fromMap(Map<String, dynamic> map) {
    return PlanState(
      area: map['area'] ?? '',
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      //문자열로 저장한 데이터를 역으로 변환
      planList: (jsonDecode(map['planList']) as List)
        .map(
          (dayList) => (dayList as List)
              .map((plan) => PlanModel.fromMap(plan))
              .toList(),
        )
        .toList(),
    );
  }

  PlanState copyWith({
    String? area,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? dateList,
    List<List<PlanModel>>? planList,
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
  final FirePlanRepository repo = FirePlanRepository();
  final String userId = 'test_user';

  @override
  PlanState build() {
    return PlanState(
      area: '',
      startDate: DateTime(1970, 1, 1),
      endDate: DateTime(1970, 1, 1),
      planList: [],
    );
  }

  //플랜뷰모델 초기화
  void planClear() {
    state = PlanState(
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

    if (state.endDate != DateTime(1970, 1, 1)) {
      final days = state.endDate.difference(state.startDate).inDays + 1;
      while (state.planList.length < days) {
        state.planList.add([]);
      }
    }
  }

  //도착 날짜
  void updateEndDate(DateTime date) {
    state = state.copyWith(endDate: date);

    if (state.startDate != DateTime(1970, 1, 1)) {
      final days = state.endDate.difference(state.startDate).inDays + 1;
      while (state.planList.length < days) {
        state.planList.add([]);
      }
    }
  }

  //할일추가
  void addTodo(int dateIndex, PlanModel todo) {
    final newPlanList = List<List<PlanModel>>.from(state.planList);
    while (newPlanList.length <= dateIndex) {
      newPlanList.add([]);
    }
    newPlanList[dateIndex] = [...newPlanList[dateIndex], todo];
    state = state.copyWith(planList: newPlanList);
  }

  //할 일 순서 바꿈
  void reorderTodo(int dayIndex, int oldIndex, int newIndex) {
    final newList = List<List<PlanModel>>.from(state.planList);
    final todayPlans = List<PlanModel>.from(newList[dayIndex]);

    final item = todayPlans.removeAt(oldIndex);
    todayPlans.insert(newIndex, item);

    newList[dayIndex] = todayPlans;
    state = state.copyWith(planList: newList);
  }

  //할 일 삭제
  void deleteTodo(int dayIndex, int todoIndex) {
    final newList = List<List<PlanModel>>.from(state.planList);
    final todayPlans = List<PlanModel>.from(newList[dayIndex]);

    todayPlans.removeAt(todoIndex);

    newList[dayIndex] = todayPlans;
    state = state.copyWith(planList: newList);
  }

  // ---------------- Firestore 연동 ----------------
  Future<void> savePlanToFirestore({String? planId}) async {
    await repo.savePlan(userId, state, planId: planId);
  }

  Future<void> loadPlansFromFirestore() async {
    final plans = await repo.getPlan(userId);
    if (plans.isNotEmpty) {
      state = plans.first;
    }
  }

  Future<void> deletePlanFromFirestore(String planId) async {
    await repo.deletePlan(userId, planId);
  }

}

final planViewModelProvider = NotifierProvider<PlanViewModel, PlanState>(
  () => PlanViewModel(),
);
