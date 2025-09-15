import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class DialogTextFormField extends StatelessWidget {
  String title;
  String? hintText;
  TextEditingController controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator? validator;
  int maxLines;
  DialogTextFormField({
    super.key,
    required this.title,
    this.hintText,
    required this.controller,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
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
