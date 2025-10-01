import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/my/model/user_model.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
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
    auth.auth.authStateChanges().listen((user) async {
      state = state.copyWith(user: user, isSignedIn: user != null);

      print('Firebase Auth 상태 변화 감지 Firebase user: ${user?.uid}, ${user?.displayName}================================');

      if (user != null) {
        final userVm = ref.read(userViewModelProvider.notifier);
        final planVm = ref.read(myPlanViewModelProvider.notifier);
        

        // Firestore에서 UserModel 가져오기
        UserModel? userModel = await userVm.repository.getUser(user.uid);

        if (userModel != null) {
          // Firestore 데이터가 있으면 state 반영
          userVm.setUserModel(userModel);
        } else {
          // Firestore에 데이터 없으면 새로 생성
          userModel = UserModel.fromFirebaseUser(user);
          print('생성된 UserModel ID: ${userModel.id}');
          userVm.setUserModel(userModel);
          await userVm.repository.saveUser(userModel);
        }

        // PlanList 업데이트
        await planVm.loadPlanList(user.uid);

        print('Firebase Auth 상태 변화 감지: ${user.uid}, ${user.displayName}================================');
        print('userModel이 잘 업데이트 되나??: ${userModel.id}, ${userModel.displayName}================================');
      } else {
        // 로그아웃 시 초기화
        ref.read(userViewModelProvider.notifier).clearUser();
        ref.read(myPlanViewModelProvider.notifier).state = PlanListState(plans: []);
      }
    });
    
    return AuthState(
      user: auth.currentUser,
      isSignedIn: auth.currentUser != null,
    );
  }

  /// 구글 로그인
  Future<bool> signInWithGoogle() async {
    final currentUser = await auth.signInWithGoogle();
    if (currentUser != null) {
      await updateUserState(currentUser);
      return true;
    }
    return false;
  }

  /// 애플 로그인
  Future<bool> signInWithApple() async {
    final currentUser = await auth.signInWithApple();
    if (currentUser != null) {
      await updateUserState(currentUser);
      return true;
    }
    return false;
  }

  /// 익명 로그인
  Future<bool> signInAnonymously() async {
    final currentUser = await auth.signInAnonymously();
    if (currentUser != null) {
      await updateUserState(currentUser);
      return true;
    }
    return false;
  }

  /// 로그아웃
  Future<void> signOut() async {
    await auth.signOut();
    state = state.copyWith(user: null, isSignedIn: false);
    ref.read(userViewModelProvider.notifier).clearUser();
    ref.read(myPlanViewModelProvider.notifier).clearPlanList();
  }

  /// 회원 탈퇴
  Future<void> deleteAccount() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.delete();
        await auth.signOut();
        state = state.copyWith(user: null, isSignedIn: false);
        ref.read(userViewModelProvider.notifier).clearUser();
        ref.read(myPlanViewModelProvider.notifier).clearPlanList();
      }
    } catch (e) {
      print('계정 삭제 실패: $e');
    }
  }

  /// 로그인 후 UserModel과 PlanList 업데이트
  Future<void> updateUserState(User currentUser) async {
    state = state.copyWith(user: currentUser, isSignedIn: true);

    final userVm = ref.read(userViewModelProvider.notifier);
    final planVm = ref.read(myPlanViewModelProvider.notifier);

    print('로그인 후 Firebase user: ${currentUser.uid}, ${currentUser.displayName}================================');

    // Firestore에서 UserModel 가져오기
    UserModel? userModel = await userVm.repository.getUser(currentUser.uid);

    print('로그인 후 UserModel과 PlanList 업데이트: ${userModel?.id}, ${userModel?.displayName}================================');

    if (userModel != null) {
      userVm.setUserModel(userModel);
    } else {
      userModel = UserModel.fromFirebaseUser(currentUser);
      print('생성된 UserModel ID: ${userModel.id}');
      userVm.setUserModel(userModel);
      await userVm.repository.saveUser(userModel);
    }

    // PlanList 업데이트
    await planVm.loadPlanList(currentUser.uid);
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
