import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class PlanDateWidget extends ConsumerStatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool isStartDate;

  const PlanDateWidget({super.key, this.hintText, this.labelText, this.isStartDate = true});

  @override
  ConsumerState<PlanDateWidget> createState() => _PlanDateWidgetState();
}

class _PlanDateWidgetState extends ConsumerState<PlanDateWidget> {
  DateTime? selectedDate;
  late final PlanViewModel planState;


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      locale: const Locale('ko'), 
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if(pickedDate != null){
      setState(() {
        selectedDate = pickedDate;

        //뷰모델에 전달
        if(widget.isStartDate){
          planState.updateStartDate(selectedDate!);
        }else{
          planState.updateEndDate(selectedDate!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    planState = ref.read(planViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            _selectDate();
          },
          child: Container(
            width: double.infinity,
            height: 56,
            padding: EdgeInsets.fromLTRB(77, 16, 16, 16),
            decoration: BoxDecoration(
              border: BoxBorder.all(color: colGreyBtn, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: 
            selectedDate != null
            ? Text('${selectedDate!.year}년 ${selectedDate!.month}월 ${selectedDate!.day}일', style: AppTxtSt.txtStL,)
            : Text('날짜를 선택해주세요', style: AppTxtSt.hintStL,)
          ),
        ),
        Positioned(
          right: 16,
          top: 17,
          child: Text('선택', style: AppTxtSt.txtPrimary),
        ),
        Positioned(
          left: 16,
          top: 17,
          child: Text(widget.labelText!, style: AppTxtSt.txtStL),
        ),
      ],
    );
  }
}
