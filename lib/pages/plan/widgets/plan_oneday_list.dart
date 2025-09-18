import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_item_widget.dart';

class PlanOnedayList extends StatelessWidget {
  PlanOnedayList({
    super.key,
    required this.planState,
    required this.today,
    required this.totalDays,
  });
  PlanState planState;
  int today;
  int totalDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: colGreyBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (today > 0 && totalDays != 0)
                  ? GestureDetector(
                      onTap: () {
                        print('클릭!');
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: EdgeInsets.all(16),
                        color: Colors.transparent,
                        child: Image.asset('assets/images/icon_back.png'),
                      ),
                    )
                  : SizedBox(width: 56, height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Day ${today + 1} ', style: AppTxtSt.txtStLB),
                  Text('25.09.18', style: AppTxtSt.txtStR),
                ],
              ),
              (today < totalDays && today != totalDays - 1)
                  ? GestureDetector(
                      onTap: () {
                        print('클릭!');
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: EdgeInsets.all(16),
                        color: Colors.transparent,
                        child: Image.asset('assets/images/icon_go_arrow.png'),
                      ),
                    )
                  : SizedBox(width: 56, height: 56),
            ],
          ),
        ),
        SizedBox(height: 20,),
        (planState.planList[today].isEmpty)
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
                      key: ValueKey(planState.planList[index]),
                      index: index,
                      item: planState.planList[today][index], 
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = planState.planList.removeAt(oldIndex);
                    planState.planList.insert(newIndex, item);
                  },
                ),
              ),
      ],
    );
  }
}
