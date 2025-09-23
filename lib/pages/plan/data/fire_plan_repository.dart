import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class FirePlanRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // 유저별 plans 컬렉션 가져오기
  CollectionReference getUserPlan(String userId) {
    return firestore.collection('users').doc(userId).collection('plans');
  }

  // PlanState 저장
  Future<String?> savePlan(String userId, PlanState plan) async {
    final plansRef = getUserPlan(userId);

    if (plan.planId == null) {
      final docRef = await plansRef.add(plan.toMap());
      await docRef.update({'planId': docRef.id});
      return docRef.id;
    } else {
      await plansRef.doc(plan.planId).update(plan.toMap());
      return plan.planId;
    }
  }

  // Plan 리스트 불러오기
  Future<List<PlanState>> getPlan(String userId) async {
    try {
      final plan = await getUserPlan(userId).get();
      final planList = plan.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PlanState.fromMap({...data, 'planId': doc.id});
      }).toList();
      return planList;
    } catch (e) {
      print('Plan 리스트 불러오기에서 error발생!! $e');
      return [];
    }
  }

  //Plan id로 1개만 찾기
  Future<PlanState?> getPlanById(String userId, String planId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans')
        .doc(planId)
        .get();

    if (!doc.exists) return null;

    return PlanState.fromMap(doc.data()!);
  }

  // PlanState 삭제
  Future<void> deletePlan(String userId, String planId) async {
    await getUserPlan(userId).doc(planId).delete();
  }
}
