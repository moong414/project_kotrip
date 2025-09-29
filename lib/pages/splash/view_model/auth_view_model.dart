import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/splash/data/fire_auth_repository.dart';

class AuthState {
  final User? user;
  bool isSignedIn;
  AuthState({required this.user, required this.isSignedIn});

  AuthState copyWith({User? user, bool? isSignedIn}) {
    return AuthState(
      user: user ?? this.user,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  late final FirebaseAuthRepository auth;
  late final Stream<User?> authStateChanges;

  @override
  AuthState build() {
    auth = FirebaseAuthRepository();
    auth.auth.authStateChanges().listen((user) {
        state = state.copyWith(user: user, isSignedIn: user != null);
      });
    return AuthState(user: auth.currentUser, isSignedIn: auth.currentUser != null);
  }

  //현재 로그인 상태갱신&로그인상태반환
  bool authState() {
    final currentUser = auth.currentUser;
    final currenSignin = currentUser != null; //currentUser가 있으면 true
    state = state.copyWith(user: currentUser, isSignedIn: currentUser != null);
    return currenSignin;
  }

  //구글로그인
  Future<bool> signInWithGoogle() async {
    final currentUser = await auth.signInWithGoogle();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      return true;
    }
    return false;
  }

  //애플로그인
  Future<bool> signInWithApple() async {
    final currentUser = await auth.signInWithApple();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      return true;
    }
    return false;
  }

  //익명 로그인
  Future<bool> signInAnonymously() async {
    final currentUser = await auth.signInAnonymously();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      return true;
    }
    return false;
  }

  //로그아웃
  Future<void> signOut() async {
    await auth.signOut();
    state = state.copyWith(user: null, isSignedIn: false);
  }

  //회원 탈퇴
  Future<void> deleteAccount() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.delete(); // Firebase에서 계정 삭제
        await auth.signOut();
        state = state.copyWith(user: null, isSignedIn: false);
      }
      return;
    } catch (e) {
      print('계정 삭제 실패: $e');
      return;
    }
  }


}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
