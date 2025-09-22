import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/my/widgets/my_plan_link.dart';
import 'package:project_kotrip/pages/my/widgets/my_review_link.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  late final authState = ref.read(authViewModelProvider);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(myPlanViewModelProvider.notifier)
          .loadPlanList(authState.user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myPlans = ref.watch(myPlanViewModelProvider);

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colGrBg,
          ),
          child: Row(
            children: [
              Text('안녕하세요! ', style: AppTxtSt.txtStL),
              Text(
                '${authState.user?.displayName}',
                style: AppTxtSt.txtStLB,
                overflow: TextOverflow.ellipsis,
              ),
              Text(' 님', style: AppTxtSt.txtStL),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20),
          child: Text('내 여행 계획 보기', style: AppTxtSt.titleSt),
        ),
        myPlans.plans.isEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(color: colGreyBtn),
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
                itemCount: myPlans.plans.length,
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
        Padding(
          padding: EdgeInsetsGeometry.only(top: 20, bottom: 10),
          child: Text('내 리뷰 보기', style: AppTxtSt.titleSt),
        ),
        MyReviewLink(),
        MyReviewLink(),
        MyReviewLink(),
        GestureDetector(
          onTap: () {
            //탈퇴
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            color: Colors.transparent,
            child: Text('탈퇴하기', textAlign: TextAlign.end),
          ),
        ),
      ],
    );
  }
}
