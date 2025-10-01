import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';

//마이페이지 유저정보 수정 파이어스토어 저장
class FireUserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //user 컬렉션 가져오기
  CollectionReference get users => firestore.collection('users');

  //마이페이스 user정보 저장
  Future<void> saveUser(UserModel user) async {
    await users.doc(user.id).set(user.toMap());
  }

  //userId로 firestore에서 user정보 가져오기
  Future<UserModel?> getUser(String userId) async {
    final doc = await users.doc(userId).get();
    if (doc.exists == false) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  //업데이트
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
  final docRef = users.doc(userId);
  final doc = await docRef.get();

  if (doc.exists) {
    await docRef.update(data);
  } else {
    await docRef.set(data, SetOptions(merge: true));
  }
}
}
