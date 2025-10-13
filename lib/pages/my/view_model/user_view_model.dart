import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/data/fire_user_repository.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';

// 유저정보 상태
class UserState {
  final UserModel? user;

  UserState({this.user});

  UserState copyWith({UserModel? user}) {
    return UserState(user: user ?? this.user);
  }
}

class UserViewModel extends Notifier<UserState> {
  final FireUserRepository repository = FireUserRepository();

  @override
  UserState build() {
    return UserState();
  }

  // Firestore에서 유저 정보 불러오기
  Future<void> loadUser(String userId) async {
    final user = await repository.getUser(userId);
    state = state.copyWith(user: user);
  }

  // 뷰에서 직접 유저 세팅
  void setUserModel(UserModel user) {
    state = state.copyWith(user: user);
  }

  // 닉네임, 주소 변경 후 Firestore에 저장 (문서 없으면 생성)
  Future<bool> setUser({String? nickName, String? address}) async {
    final currentUser = state.user;
    if (currentUser == null || currentUser.id.isEmpty) {
      print('Firestore 저장 실패: 유효한 id가 없습니다.');
      return false;
    }

    final updatedUser = currentUser.copyWith(
      nickName: nickName,
      address: address,
    );

    state = state.copyWith(user: updatedUser);

    try {
      await repository.updateUser(updatedUser.id, {
        'nickName': updatedUser.nickName,
        'address': updatedUser.address,
      });
      return true;
    } catch (e) {
      print('Firestore 저장 실패: $e');
      return false;
    }
  }

  // 약관동의 업데이트
  Future<void> updateAgreedTerms(bool value) async {
    final user = state.user;
    if (user == null) return;
    await repository.updateUserField(user.id, 'hasAgreedTerms', value);
    state = state.copyWith(user: user.copyWith(hasAgreedTerms: value));
  }

  // 튜토리얼 완료 업데이트
  Future<void> updateTutorialDone(bool value) async {
    final user = state.user;
    if (user == null) return;

    await repository.updateUserField(user.id, 'hasSeenTutorial', value);
    state = state.copyWith(user: user.copyWith(hasSeenTutorial: value));
  }

  // 로그아웃: 상태 초기화
  void clearUser() {
    state = state.copyWith(user: null);
  }
}

// Provider
final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(
  () => UserViewModel(),
);
