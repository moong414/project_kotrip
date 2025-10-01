import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String? displayName;
  final String? nickName;
  final String address;

  UserModel({
    required this.id,
    this.displayName,
    this.nickName,
    this.address = '주소가 없습니다.',
  });

  UserModel copyWith({
    String? id,
    String? displayName,
    String? nickName,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      nickName: nickName ?? this.nickName,
      address: address ?? this.address,
    );
  }

  /// Firebase User -> UserModel 변환
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      displayName: user.displayName ?? '이름 없음', 
      nickName: user.displayName ?? '익명',  
      address: '주소가 없습니다.',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'nickName': nickName,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '이름 없음',
      nickName: map['nickName'] ?? '익명',
      address: map['address'] ?? '주소가 없습니다.',
    );
  }
}
