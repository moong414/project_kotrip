import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/core/widgets/dialog_text_form_field.dart';

class PlanFloatingBtn extends StatelessWidget {
  const PlanFloatingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {
          showPlanDialog(context);
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

void showPlanDialog(BuildContext context) {
  final timeCon = TextEditingController();
  final placeCon = TextEditingController();
  final contentCon = TextEditingController();

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
                  Text('Day 1', style: AppTxtSt.txtStLB),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.black, size: 24,),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 80, child: Text('시간')),
                          Expanded(
                            child: DialogTextFormField(title: '시간', controller: timeCon, hintText: '시간을 입력하세요',),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 80, child: Text('장소')),
                          Expanded(
                            child: DialogTextFormField(title: '장소', controller: placeCon, hintText: '장소를 입력하세요',),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: 80, child: Text('할 일')),
                          Expanded(
                            child: DialogTextFormField(title: '할 일', controller: contentCon, hintText: '할 일을 입력하세요', maxLines: 3,),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      AppButton(onPressed: (){}, bgColor: colBkBtn, text: '작성',)
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
