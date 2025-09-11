import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';

class AppButton extends StatelessWidget {
  final Color? bgColor;
  final Color? txtColor;
  final String? text;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    this.bgColor,
    this.txtColor,
    this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
          backgroundColor: bgColor ?? primary,
        ),
        child: Text(text ?? '확인', style: TextStyle(color: txtColor ?? Colors.white, fontSize: 16)),
      ),
    );
  }
}
