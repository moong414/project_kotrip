import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';

class UserState{
  final UserModel? user;
  UserState({this.user});

  UserState copyWith({UserModel? user}){
    return UserState(user: user ?? this.user);
  }
}

class UserViewModel extends Notifier<UserState>{
  @override
  UserState build() {
    return UserState();
  }

  //auth_view_model에서 사용할 유저세팅용
  void setUserModel(UserModel user) {
    state = state.copyWith(user: user);
  }

  //닉네임, 주소 변경
  void setUser({String? nickName, String? address}){
    if(state.user == null) return;
    state = state.copyWith(user: state.user!.copyWith(
      nickName: nickName,
      address: address
    ));
  }

  //유저state없애기
  void clearUser(){
    state = state.copyWith(user: null);
  }
}

final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(() {
  return UserViewModel();
},);