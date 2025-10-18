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
  
  // 특정 유저의 필드만 업데이트
  Future<void> updateUserField(String userId, String key, dynamic value) async {
    final docRef = users.doc(userId);
    await docRef.update({key: value});
  }

  //유저 컬렉션 삭제
  Future<void> deleteUser(String userId) async {
    try {
      final docRef = firestore.collection('users').doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
        print('Firestore 유저 문서 삭제 완료: $userId');
      } else {
        print('삭제할 유저 문서가 존재하지 않음: $userId');
      }
    } catch (e) {
      print('Firestore 유저 문서 삭제 실패: $e');
    }
  }

}
