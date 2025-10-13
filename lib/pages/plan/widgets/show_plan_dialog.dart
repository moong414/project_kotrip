import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/model/plan_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';

Future<void> showPlanDialog(BuildContext context, WidgetRef ref, int thisPage, {PlanModel? planmodel, int? index}) async {
  final isEdit = planmodel != null; //수정인지 추가인지 구분
  final timeCon = TextEditingController(text: planmodel?.time ?? '');
  final placeCon = TextEditingController(text: planmodel?.place ?? '');
  final todoCon = TextEditingController(text: planmodel?.todo ?? '');

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 10, 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Day ${thisPage + 1}', style: AppTxtSt.txtStLB),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.black, size: 24),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 80, child: Text('시간')),
                          Expanded(
                            child: DialogTextFormField(controller: timeCon, hintText: '시간을 입력하세요', autoFocus: true),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 80, child: Text('장소')),
                          Expanded(
                            child: DialogTextFormField(controller: placeCon, hintText: '장소를 입력하세요'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: 80,
                            child: Text('할 일'),
                          ),
                          Expanded(
                            child: DialogTextFormField(controller: todoCon, hintText: '할 일을 입력하세요', maxLines: 3),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        onPressed: () {
                         final plan = PlanModel(
                            time: timeCon.text.trim(),
                            place: placeCon.text.trim(),
                            todo: todoCon.text.trim(),
                          );

                          final notifier = ref.read(planViewModelProvider.notifier);

                          if (isEdit && index != null) {
                            ref.read(planViewModelProvider.notifier)
                                .updateTodo(thisPage, index, plan);
                          } else {
                            ref.read(planViewModelProvider.notifier)
                                .addTodo(thisPage, plan);
                          }
                          Navigator.pop(context);
                        },
                        bgColor: colBkBtn,
                        height: 50,
                        text: isEdit ? '수정하기' : '작성',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
