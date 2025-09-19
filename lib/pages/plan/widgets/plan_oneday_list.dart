import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_item_widget.dart';

class PlanOnedayList extends ConsumerWidget {
  PlanOnedayList({super.key, required this.today, required this.totalDays});
  int today;
  int totalDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planViewModelProvider);
    final planViewModel = ref.read(planViewModelProvider.notifier);
    final hasPlans =
        planState.planList.length > today &&
        planState.planList[today].isNotEmpty;

    return (!hasPlans)
        ? Expanded(
            child: Center(
              child: Text(
                '일정을 추가해보세요!',
                style: AppTxtSt.txtStL.copyWith(color: Color(0xff999999)),
              ),
            ),
          )
        : Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: planState.planList[today].length,
              itemBuilder: (context, index) {
                return PlanItemWidget(
                  key: ValueKey('${today}_$index'),
                  index: index,
                  item: planState.planList[today][index],
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                planViewModel.reorderTodo(today, oldIndex, newIndex);
              },
            ),
          );
  }
}
