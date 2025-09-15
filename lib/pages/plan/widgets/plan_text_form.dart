import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PlanTextForm extends StatelessWidget {
  final baseBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colGreyBtn, width: 1),
  );
  final String? hintText;
  final TextEditingController controller;
  final bool? isLabel;
  final String? labelText;

  PlanTextForm({
    super.key,
    this.hintText,
    required this.controller,
    this.isLabel = false,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          readOnly: true,
          cursorColor: colPrimary,
          decoration: InputDecoration(
            contentPadding: (isLabel ?? false)
                ? EdgeInsets.fromLTRB(77, 16, 16, 16)
                : EdgeInsets.all(16),
            hintText: hintText ?? '입력해주세요',
            hintStyle: AppTxtSt.txtStL.copyWith(color: Colors.grey),
            border: baseBorder,
            disabledBorder: baseBorder,
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(color: colPrimary),
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: Text('선택', style: AppTxtSt.txtPrimary),
        ),
        if (isLabel ?? false)
          Positioned(
            left: 16,
            top: 16,
            child: Text(labelText!, style: AppTxtSt.txtStL),
          ),
      ],
    );
  }
}
