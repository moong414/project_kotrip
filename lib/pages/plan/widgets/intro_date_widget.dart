import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class IntroDateWidget extends ConsumerStatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool isStartDate;

  const IntroDateWidget({
    super.key,
    this.hintText,
    this.labelText,
    this.isStartDate = true,
  });

  @override
  ConsumerState<IntroDateWidget> createState() => _IntroDateWidgetState();
}

class _IntroDateWidgetState extends ConsumerState<IntroDateWidget> {
  DateTime? selectedDate;
  late final PlanViewModel planState;

  //날짜선택
  Future<void> _selectDate(FormFieldState<DateTime> field) async {
    final DateTime? pickedDate = await showDatePicker(
      locale: const Locale('ko'), //한국어
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        field.didChange(pickedDate);
        //뷰모델에 전달
        if (widget.isStartDate) {
          planState.updateStartDate(selectedDate!);
        } else {
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
    final state = ref.watch(planViewModelProvider);
    return FormField<DateTime>(
      validator: (value) {
        if (value == null) {
          return widget.isStartDate ? '시작일을 선택하세요' : '도착일을 선택하세요';
        }
        if (!widget.isStartDate && value.isBefore(state.startDate)) {
          return '도착일은 시작일 이후여야 합니다';
      }
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _selectDate(field);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    padding: EdgeInsets.fromLTRB(77, 16, 16, 16),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(
                        color: field.hasError ? Color(0xffBE2C48) : colGreyBtn,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: selectedDate != null
                        ? Text(
                            '${selectedDate!.year}년 ${selectedDate!.month}월 ${selectedDate!.day}일',
                            style: AppTxtSt.txtStL,
                          )
                        : Text('날짜를 선택해주세요', style: AppTxtSt.hintStL),
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
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 16),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: Color(0xffBE2C48),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
