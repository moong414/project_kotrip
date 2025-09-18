import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PlanDateWidget extends StatefulWidget {
  final String? hintText;
  final String? labelText;

  const PlanDateWidget({super.key, this.hintText, this.labelText});

  @override
  State<PlanDateWidget> createState() => _PlanDateWidgetState();
}

class _PlanDateWidgetState extends State<PlanDateWidget> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      locale: const Locale('ko'), 
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _selectDate,
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
