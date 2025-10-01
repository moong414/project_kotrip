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

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(id: user.uid, displayName: user.displayName);
  }

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
      id: map['id'],
      displayName: map['displayName'],
      nickName: map['nickName'],
      address: map['address'] ?? '주소가 없습니다.',
    );
  }
}
