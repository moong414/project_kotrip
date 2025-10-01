import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/show_confirm_dialog.dart';
import 'package:project_kotrip/pages/my/info_edit_page.dart';
import 'package:project_kotrip/pages/my/my_plan_list_page.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/my/widgets/my_plan_link.dart';
import 'package:project_kotrip/pages/my/widgets/my_review_link.dart';
import 'package:project_kotrip/pages/splash/splash_page.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authFunc = ref.read(authViewModelProvider.notifier);
    final myPlans = ref.watch(myPlanViewModelProvider);
    final userState = ref.watch(userViewModelProvider).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--유저 정보--
          Container(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colGrBg,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 6),
                        Text('안녕하세요! ', style: AppTxtSt.txtStL),
                        Text(
                          userState?.nickName ?? userState?.displayName ?? '익명',
                          style: AppTxtSt.txtStLB,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(' 님', style: AppTxtSt.txtStL),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoEditPage();
                            },
                          ),
                        );
                      },
                      icon: Image.asset(
                        'assets/images/icon_setting.png',
                        width: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/icon_location.png', width: 20),
                      SizedBox(width: 6),
                      Text(
                        userState!.address,
                        style: (userState.address != '주소가 없습니다.')
                            ? AppTxtSt.txtStL
                            : AppTxtSt.hintStL,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //--내 여행 계획--
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('내 여행 계획 보기', style: AppTxtSt.titleSt),
                myPlans.plans.isEmpty
                    ? SizedBox(height: 32)
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPlanListPage();
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          color: Colors.transparent,
                          child: Text('more', style: AppTxtSt.txtPrimary),
                        ),
                      ),
              ],
            ),
          ),
          myPlans.plans.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colGreyBtn),
                  ),
                  child: Text(
                    '계획이 없습니다.',
                    style: AppTxtSt.hintStR,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: min(1, myPlans.plans.length),
                  itemBuilder: (context, index) {
                    return MyPlanLink(
                      myPlans: myPlans.plans[index],
                      authState: authState,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                ),
          //Todo: 내 리뷰 기능
          Padding(
            padding: EdgeInsetsGeometry.only(top: 20, bottom: 10),
            child: Text('내 리뷰 보기', style: AppTxtSt.titleSt),
          ),
          MyReviewLink(),
          SizedBox(height: 10),
          //-- 로그아웃 버튼 --
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  final confirm = await showConfirmDialog(
                    context,
                    '로그아웃 하시겠습니까?',
                  );
                  if (confirm == true) {
                    await authFunc.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SplashPage()),
                    );
                  }
                },
                child: Text('로그아웃', style: AppTxtSt.txtStR),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
