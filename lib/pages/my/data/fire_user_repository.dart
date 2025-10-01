import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';

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

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await users.doc(userId).update(data);
  }
}
