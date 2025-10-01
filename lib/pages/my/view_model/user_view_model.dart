import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/data/fire_user_repository.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';

//유저정보
class UserState {
  final UserModel? user;

  UserState({this.user});

  UserState copyWith({UserModel? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
    );
  }
}

class UserViewModel extends Notifier<UserState> {
  final FireUserRepository repository = FireUserRepository();

  @override
  UserState build() {
    return UserState();
  }

  // Firestore에서 유저정보 가져오기
  Future<void> loadUser(String userId) async {
    final user = await repository.getUser(userId);
    state = state.copyWith(user: user);
  }

  // 유저 세팅 (뷰에서 직접)
  void setUserModel(UserModel user) {
    state = state.copyWith(user: user);
  }

  // 닉네임, 주소 변경 후 Firestore에 저장
  Future<void> setUser({String? nickName, String? address}) async {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      nickName: nickName,
      address: address,
    );

    state = state.copyWith(user: updatedUser);
    await repository.updateUser(updatedUser.id, {
      'nickName': updatedUser.nickName,
      'address': updatedUser.address,
    });
  }

  // 로그아웃 시 state 초기화
  void clearUser() {
    state = state.copyWith(user: null);
  }
}

final userViewModelProvider =
    NotifierProvider<UserViewModel, UserState>(() => UserViewModel());
