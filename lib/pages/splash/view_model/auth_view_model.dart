import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/splash/data/fire_auth_repository.dart';

class AuthState {
  final User? user;
  final bool isSignedIn;
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

  @override
  AuthState build() {
    auth = FirebaseAuthRepository();

    // Firebase Auth 상태 변화 감지
    auth.auth.authStateChanges().listen((user) {
      state = state.copyWith(user: user, isSignedIn: user != null);

      // UserModel도 함께 업데이트
      if (user != null) {
        ref.read(userViewModelProvider.notifier).setUserModel(UserModel.fromFirebaseUser(user));
      } else {
        ref.read(userViewModelProvider.notifier).clearUser();
      }
    });

    return AuthState(
      user: auth.currentUser,
      isSignedIn: auth.currentUser != null,
    );
  }

  /// 현재 로그인 상태 반환 + 갱신
  bool authState() {
    final currentUser = auth.currentUser;
    final currentSignedIn = currentUser != null;
    state = state.copyWith(user: currentUser, isSignedIn: currentSignedIn);

    if (currentUser != null) {
      ref.read(userViewModelProvider.notifier).setUserModel(UserModel.fromFirebaseUser(currentUser));
    } else {
      ref.read(userViewModelProvider.notifier).clearUser();
    }

    return currentSignedIn;
  }

  /// 구글 로그인
  Future<bool> signInWithGoogle() async {
    final currentUser = await auth.signInWithGoogle();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      ref.read(userViewModelProvider.notifier).setUserModel(UserModel.fromFirebaseUser(currentUser));
      return true;
    }
    return false;
  }

  /// 애플 로그인
  Future<bool> signInWithApple() async {
    final currentUser = await auth.signInWithApple();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      ref.read(userViewModelProvider.notifier).setUserModel(UserModel.fromFirebaseUser(currentUser));
      return true;
    }
    return false;
  }

  /// 익명 로그인
  Future<bool> signInAnonymously() async {
    final currentUser = await auth.signInAnonymously();
    if (currentUser != null) {
      state = state.copyWith(user: currentUser, isSignedIn: true);
      ref.read(userViewModelProvider.notifier).setUserModel(UserModel.fromFirebaseUser(currentUser));
      return true;
    }
    return false;
  }

  /// 로그아웃
  Future<void> signOut() async {
    await auth.signOut();
    state = state.copyWith(user: null, isSignedIn: false);
    ref.read(userViewModelProvider.notifier).clearUser();
  }

  /// 회원 탈퇴
  Future<void> deleteAccount() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.delete(); // Firebase에서 계정 삭제
        await auth.signOut();
        state = state.copyWith(user: null, isSignedIn: false);
        ref.read(userViewModelProvider.notifier).clearUser();
      }
    } catch (e) {
      print('계정 삭제 실패: $e');
    }
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
