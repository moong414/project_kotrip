import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/data/plan_model.dart';

class FinishItemWidget extends StatelessWidget {
  FinishItemWidget({
    super.key,
    required this.index,
    required this.listLen,
    required this.item,
  });
  int index;
  int listLen;
  PlanModel item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(index != listLen-1)
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          width: 2,
          child: Image.asset(
            'assets/images/bg_border.png',
            repeat: ImageRepeat.repeatY,
            fit: BoxFit.none,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 16,
                height: 16,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: (index % 2 ==0) ? colPrimary : Color(0xff999999), width: 4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
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
                        Text(item.place ?? '', style: AppTxtSt.txtStR),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.todo,
                      style: AppTxtSt.txtStL,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
