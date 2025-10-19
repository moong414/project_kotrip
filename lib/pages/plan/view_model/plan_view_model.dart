import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/plan/data/gemini_repository.dart';
import 'package:project_kotrip/pages/plan/model/plan_model.dart';
import 'package:project_kotrip/pages/plan/data/fire_plan_repository.dart';
import 'dart:convert';

class PlanState {
  String area;
  DateTime startDate;
  DateTime endDate;
  List<List<PlanModel>> planList; // 날짜별 할일 리스트
  String? planId;
  //포맷날짜
  String startFormat;
  String endFormat;

  PlanState({
    required this.area,
    required this.startDate,
    required this.endDate,
    required this.planList,
    this.planId,
    required this.startFormat,
    required this.endFormat
  });

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'startDate': startDate,
      'endDate': endDate,
      //중첩된리스트는 파이어스토어에서 지원하지않아서 문자열로 바꿔서 저장하기
      'planList': jsonEncode(
        planList
            .map((list) => list.map((plan) => plan.toMap()).toList())
            .toList(),
      ),
      'planId': planId,
      'startFormat': startFormat,
      'endFormat': endFormat,
    };
  }

  factory PlanState.fromMap(Map<String, dynamic> map) {
    return PlanState(
      area: map['area'] ?? '',
      startDate: map['startDate']?.toDate(),
      endDate: map['endDate']?.toDate(),
      planList: map['planList'] != null
          ? (jsonDecode(map['planList']) as List)
              .map(
                (dayList) => (dayList as List)
                    .map((plan) => PlanModel.fromMap(plan))
                    .toList(),
              )
              .toList()
          : [],
      planId: map['planId'] ?? '',
      startFormat: map['startFormat'] ?? '',
      endFormat: map['endFormat'] ?? ''
    );
  }

  PlanState copyWith({
    String? area,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? dateList,
    List<List<PlanModel>>? planList,
    String? planId,
    String? startFormat,
    String? endFormat,
  }) {
    return PlanState(
      area: area ?? this.area,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      planList: planList ?? this.planList,
      planId: planId ?? this.planId,
      startFormat: startFormat ?? this.startFormat,
      endFormat: endFormat ?? this.endFormat
    );
  }

  void geminiCreatePlan() {}
}

class PlanViewModel extends Notifier<PlanState> {
  final FirePlanRepository repo = FirePlanRepository();
  final GeminiRepository gemini = GeminiRepository();

  @override
  PlanState build() {
    return PlanState(
      area: '',
      startDate: DateTime(1970, 1, 1),
      endDate: DateTime(1970, 1, 1),
      planList: [],
      planId: null,
      startFormat: '',
      endFormat: ''
    );
  }

  //플랜뷰모델 초기화
  void planClear() {
  state = PlanState(
    area: '',
    startDate: DateTime(1970, 1, 1),
    endDate: DateTime(1970, 1, 1),
    planList: [],
    planId: null,
    startFormat: '',
    endFormat: ''
  );
}


  // 플랜뷰모델(직접여행계획세우기) 초기화
  void prepareDirectPlan({String? area}) {
    // 장소 업데이트
    if (area != null) updatePlace(area);

    // 시작일/종료일 기본값 처리
    if (state.startDate == DateTime(1970, 1, 1)) {
      updateStartDate(DateTime.now());
    }
    if (state.endDate == DateTime(1970, 1, 1)) {
      updateEndDate(DateTime.now().add(Duration(days: 1)));
    }

    // planList 초기화 / 최소 1일
    final days = state.endDate.difference(state.startDate).inDays + 1;
    final newPlanList = List<List<PlanModel>>.from(state.planList);
    while (newPlanList.length < days) {
      newPlanList.add([]);
    }
    state = state.copyWith(planList: newPlanList);
  }


  // 장소 업데이트
  void updatePlace(String text) {
    state = state.copyWith(area: text);
  }

  //출발 날짜
  void updateStartDate(DateTime date) {
    final formatDate = DateFormat('yy.MM.dd').format(date);
    state = state.copyWith(startDate: date, startFormat: formatDate);

    if (state.endDate != DateTime(1970, 1, 1)) {
      final days = state.endDate.difference(state.startDate).inDays + 1;
      while (state.planList.length < days) {
        state.planList.add([]);
      }
    }
  }

  //도착 날짜
  void updateEndDate(DateTime date) {
    final formatDate = DateFormat('yy.MM.dd').format(date);
    state = state.copyWith(endDate: date, endFormat: formatDate);

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

  //할 일 수정
  void updateTodo(int dayIndex, int todoIndex, PlanModel updatedTodo) {
    final newPlanList = List<List<PlanModel>>.from(state.planList);
    final todayPlans = List<PlanModel>.from(newPlanList[dayIndex]);

    // 기존 위치에 수정된 아이템 교체
    todayPlans[todoIndex] = updatedTodo;

    newPlanList[dayIndex] = todayPlans;
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
  //현재스테이트만 파이어베이스에 저장
  Future<void> savePlan(String userId) async {
    final result = await repo.savePlan(userId, state);
    if (result != null) state = state.copyWith(planId: result);
  }

  //파이어베이스 현재계획 삭제
  Future<void> deletePlan(String userId, String planId) async {
    await repo.deletePlan(userId, planId);
    await ref.read(myPlanViewModelProvider.notifier).loadPlanList(userId);
  }

  //계획1개만 불러와서 상태 업데이트
  Future<void> getPlanById(String userId, String planId) async {
    final plan = await repo.getPlanById(userId, planId);
    if (plan != null) state = plan;
  }

  // ---------------- Gemini AI 연동 ----------------
  //Ai에게 맡기기
  Future<void> geminiCreatePlan(String style, Set<String> themes) async {
    final date = '${state.startDate} - ${state.endDate}';
    final area = state.area;
    final result = await gemini.geminiCreatePlan(area, date, style, themes);
    state = result;
  }
}

final planViewModelProvider = NotifierProvider<PlanViewModel, PlanState>(
  () => PlanViewModel(),
);
