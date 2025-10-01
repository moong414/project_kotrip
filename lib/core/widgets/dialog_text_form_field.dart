import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class DialogTextFormField extends StatelessWidget {
  TextEditingController controller;
  bool autoFocus;
  String hintText;
  int maxLines;
  FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  DialogTextFormField({
    super.key,
    required this.controller,
    this.autoFocus = false,
    this.hintText = '입력하세요',
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      autofocus: autoFocus,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTxtSt.hintStR,
        filled: true,
        fillColor: colGreyBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
