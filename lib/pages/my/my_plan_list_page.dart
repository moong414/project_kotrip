import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/pages/my/view_model/my_plan_view_model.dart';
import 'package:project_kotrip/pages/my/widgets/my_plan_link.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';

class MyPlanListPage extends ConsumerWidget{
  const MyPlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final myPlans = ref.watch(myPlanViewModelProvider);

    return Scaffold(
      appBar: BasicAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
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
        ),
      ),
    );
  }
}