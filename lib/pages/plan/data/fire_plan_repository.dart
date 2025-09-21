import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class FirePlanRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // 유저별 plans 컬렉션 가져오기
  CollectionReference getUserPlan(String userId) {
    return firestore.collection('users').doc(userId).collection('plans');
  }

  // PlanState 저장
  Future<void> savePlan(String userId, PlanState plan, {String? planId}) async {
    final collection = getUserPlan(userId);
    if (planId == null) {
      await collection.add(plan.toMap()); // 새 플랜 추가
    } else {
      await collection.doc(planId).set(plan.toMap()); // 기존 플랜 업데이트
    }
  }

  // PlanState 불러오기
  Future<List<PlanState>> getPlan(String userId) async {
    final plan = await getUserPlan(userId).get();
    return plan.docs
        .map((doc) => PlanState.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // PlanState 삭제
  Future<void> deletePlan(String userId, String planId) async {
    await getUserPlan(userId).doc(planId).delete();
  }
}
