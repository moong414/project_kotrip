import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/input_style.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PlanTextForm extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;

  const PlanTextForm({
    super.key,
    this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '지역을 입력하세요';
        }
        return null;
      },
      cursorColor: colPrimary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        hintText: hintText ?? '입력해주세요',
        hintStyle: AppTxtSt.hintStL,
        border: baseInputBorder,
        disabledBorder: baseInputBorder,
        enabledBorder: baseInputBorder,
        focusedBorder: baseInputBorder.copyWith(
          borderSide: baseInputBorder.borderSide.copyWith(color: colPrimary),
        ),
      ),
    );
  }
}
