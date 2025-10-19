import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/data/fire_user_repository.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/splash/data/fire_auth_repository.dart';

class AuthState {
  final User? user;
  final bool isSignedIn;
  final bool isLoading;

  AuthState({
    required this.user,
    required this.isSignedIn,
    this.isLoading = true,
  });

  AuthState copyWith({
    User? user,
    bool? isSignedIn,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  late final FirebaseAuthRepository auth;
  late final FireUserRepository userRepository;

  @override
  AuthState build() {
    auth = FirebaseAuthRepository();
    userRepository = FireUserRepository();

    state = AuthState(user: null, isSignedIn: false, isLoading: true);

    auth.auth.authStateChanges().listen((user) async {
      state = state.copyWith(
        user: user,
        isSignedIn: user != null,
        isLoading: false,
      );

      print('Firebase Auth 상태 변화 감지: ${user?.uid}, ${user?.displayName}');

      if (user != null) {
        final userVm = ref.read(userViewModelProvider.notifier);
        final planVm = ref.read(myPlanViewModelProvider.notifier);

        UserModel? userModel = await userVm.repository.getUser(user.uid);

        if (userModel != null) {
          userVm.setUserModel(userModel);
        } else {
          final newUserId = user.providerData.isNotEmpty
              ? user.providerData.first.providerId
              : 'anonymous';

          userModel = UserModel.fromFirebaseUser(user).copyWith(
            hasSeenTutorial: false,
            hasAgreedTerms: false,
          );

          print('신규 로그인 (${newUserId}) 사용자 생성');
          userVm.setUserModel(userModel);
          await userVm.repository.saveUser(userModel);
        }

        await planVm.loadPlanList(user.uid);
      } else {
        ref.read(userViewModelProvider.notifier).clearUser();
        ref.read(myPlanViewModelProvider.notifier).clearPlanList();
      }
    });

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      state = AuthState(user: currentUser, isSignedIn: true, isLoading: false);
    }

    return state;
  }

  /// 구글 로그인
  Future<bool> signInWithGoogle() async {
    final currentUser = await auth.signInWithGoogle();
    return currentUser != null;
  }

  /// 애플 로그인
  Future<bool> signInWithApple() async {
    final currentUser = await auth.signInWithApple();
    return currentUser != null;
  }

  /// 익명 로그인
  Future<bool> signInAnonymously() async {
    final currentUser = await auth.signInAnonymously();
    return currentUser != null;
  }

  /// 로그아웃
  Future<void> signOut() async {
    await auth.signOut();
    state = AuthState(user: null, isSignedIn: false, isLoading: false);
    ref.read(userViewModelProvider.notifier).clearUser();
    ref.read(myPlanViewModelProvider.notifier).clearPlanList();
  }

  /// 계정 탈퇴
  Future<void> deleteAccount() async {
    final user = auth.currentUser;
    if (user == null) return;

    final uid = user.uid;
    try {
      final userVm = ref.read(userViewModelProvider.notifier);

      // Firestore 유저 + 서브컬렉션 plans 삭제
      await userVm.repository.deleteUserWithPlans(uid);

      // Firebase Auth 계정 삭제
      await user.delete();

      // 로그아웃 및 상태 초기화
      await auth.signOut();
      state = state.copyWith(user: null, isSignedIn: false, isLoading: false);
      ref.read(userViewModelProvider.notifier).clearUser();
      ref.read(myPlanViewModelProvider.notifier).clearPlanList();

      print('계정 및 Firestore 데이터 완전 삭제 완료');
    } catch (e) {
      print('계정 삭제 실패: $e');
    }
  }

  /// 로그인 후 UserModel과 PlanList 업데이트
  Future<void> updateUserState(User currentUser) async {
    state = state.copyWith(user: currentUser, isSignedIn: true, isLoading: false);

    final userVm = ref.read(userViewModelProvider.notifier);
    final planVm = ref.read(myPlanViewModelProvider.notifier);

    UserModel? userModel = await userVm.repository.getUser(currentUser.uid);

    if (userModel != null) {
      userVm.setUserModel(userModel);
    } else {
      final newUserId = currentUser.providerData.isNotEmpty
          ? currentUser.providerData.first.providerId
          : 'anonymous';

      userModel = UserModel.fromFirebaseUser(currentUser).copyWith(
        hasSeenTutorial: false,
        hasAgreedTerms: false,
      );

      print('신규 로그인 (${newUserId}) 사용자 생성');
      userVm.setUserModel(userModel);
      await userVm.repository.saveUser(userModel);
    }

    await planVm.loadPlanList(currentUser.uid);
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
