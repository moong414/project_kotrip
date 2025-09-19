import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class PlanTopInfo extends StatelessWidget {
  const PlanTopInfo({
    super.key,
    required this.planState,
    required this.startDate,
    required this.endDate,
  });

  final PlanState planState;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(planState.area, style: AppTxtSt.titleStB),
        SizedBox(width: 8),
        Text(
          '$startDate - $endDate',
          style: AppTxtSt.txtStL,
        ),
      ],
    );
  }
}
