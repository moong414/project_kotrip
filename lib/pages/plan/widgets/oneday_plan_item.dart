import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/model/plan_model.dart';

class OnedayPlanItem extends StatelessWidget {
  OnedayPlanItem({super.key, required this.index, required this.item});
  int index;
  PlanModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 22,
            margin: EdgeInsets.only(right: 9),
            child: Image.asset('assets/images/icon_plan_list.png'),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.time,
                      style: AppTxtSt.txtStR.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.place ?? '',
                        style: AppTxtSt.txtStR,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  item.todo,
                  style: AppTxtSt.txtStL.copyWith(height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
