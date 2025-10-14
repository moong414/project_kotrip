import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/my/widgets/my_plan_link.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPlanListPage extends ConsumerStatefulWidget {
  const MyPlanListPage({super.key});

  @override
  ConsumerState<MyPlanListPage> createState() => _MyPlanListPageState();
}

class _MyPlanListPageState extends ConsumerState<MyPlanListPage> {
  //상단페이지 컨트롤러
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //페이지이동함수
  void jumpToPage(int page) {
    pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final myPlans = ref.watch(myPlanViewModelProvider);
    final pages = [
      {'title': '내 여행 계획', 'list': myPlans.plans},
      {'title': '지난 계획', 'list': myPlans.pastPlans},
    ];

    return Scaffold(
      appBar: BasicAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 상단 페이지 컨트롤러
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(pages.length, (index) => Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: currentPage == index ? colGreyBg : Colors.white,
                      ),
                      onPressed: () => jumpToPage(index),
                      child: Text('${pages[index]['title']}', style: AppTxtSt.txtStR,),
                    ),
                  ),)
              ),
              const SizedBox(height: 10),
              //목록페이지
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    //페이지이동
                    setState(() {currentPage = index;});
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    final plans = page['list'] as List;
                    if (plans.isEmpty) {
                    return Center(
                      child: Text(
                        '${page.values.first}이 없습니다.',
                        style: AppTxtSt.hintStL,
                      ),
                    );
                  }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: plans.length,
                      itemBuilder: (context, i) {
                        return MyPlanLink(
                          myPlans: plans[i],
                          authState: authState,
                        );
                      },
                      separatorBuilder: (context, i) => const SizedBox(height: 10),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
