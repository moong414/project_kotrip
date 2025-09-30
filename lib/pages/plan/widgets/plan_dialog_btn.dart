import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/model/plan_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';

class PlanDialogBtn extends ConsumerWidget {
  PlanDialogBtn({super.key, required this.thisPage});
  int thisPage;

  //다이얼로그
  void showPlanDialog(BuildContext context, WidgetRef ref) {
    final timeCon = TextEditingController();
    final placeCon = TextEditingController();
    final todoCon = TextEditingController();

    showDialog(
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
                      onPressed: () {
                        return Navigator.pop(context);
                      },
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
                              child: DialogTextFormField(controller: timeCon, hintText: '시간을 입력하세요', autoFocus: true,)
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 80, child: Text('장소')),
                            Expanded(
                              child: DialogTextFormField(controller: placeCon, hintText: '장소를 입력하세요',)
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
                              child: DialogTextFormField(controller: todoCon, hintText: '할 일을 입력하세요', maxLines: 3,)
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        AppButton(
                          onPressed: () {
                            //할일 목록에 추가
                            ref
                                .read(planViewModelProvider.notifier)
                                .addTodo(
                                  thisPage,
                                  PlanModel(
                                    time: timeCon.text.replaceAll('\n', '').trim(),
                                    place: placeCon.text.replaceAll('\n', '').trim(),
                                    todo: todoCon.text.replaceAll('\n', '').trim(),
                                  ),
                                );
                            Navigator.pop(context);
                          },
                          bgColor: colBkBtn,
                          height: 50,
                          text: '작성',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {
          showPlanDialog(context, ref);
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
