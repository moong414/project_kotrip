import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String? displayName;
  final String? nickName;
  final String address;
  final bool hasSeenTutorial; // 튜토리얼 완료 여부
  final bool hasAgreedTerms;  // 약관 동의 여부

  UserModel({
    required this.id,
    this.displayName,
    this.nickName,
    this.address = '주소가 없습니다.',
    this.hasSeenTutorial = false,
    this.hasAgreedTerms = false,
  });

  UserModel copyWith({
    String? id,
    String? displayName,
    String? nickName,
    String? address,
    bool? hasSeenTutorial,
    bool? hasAgreedTerms,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      nickName: nickName ?? this.nickName,
      address: address ?? this.address,
      hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
      hasAgreedTerms: hasAgreedTerms ?? this.hasAgreedTerms,
    );
  }

  /// Firebase User -> UserModel 변환
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      displayName: user.displayName ?? '이름 없음',
      nickName: user.displayName ?? '익명',
      address: '주소가 없습니다.',
      hasSeenTutorial: false,
      hasAgreedTerms: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'nickName': nickName,
      'address': address,
      'hasSeenTutorial': hasSeenTutorial,
      'hasAgreedTerms': hasAgreedTerms,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '이름 없음',
      nickName: map['nickName'] ?? '익명',
      address: map['address'] ?? '주소가 없습니다.',
      hasSeenTutorial: map['hasSeenTutorial'] ?? false,
      hasAgreedTerms: map['hasAgreedTerms'] ?? false,
    );
  }
}
