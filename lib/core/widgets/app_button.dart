import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';

class AppButton extends StatelessWidget {
  final double? height;
  final Color? bgColor;
  final Color? txtColor;
  final String? text;
  final VoidCallback? onPressed;
  final Image? img;

  const AppButton({
    super.key,
    this.height,
    this.bgColor,
    this.txtColor,
    this.text,
    required this.onPressed,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
          backgroundColor: bgColor ?? colPrimary,
        ),
        child: Text(text ?? '확인', style: TextStyle(color: txtColor ?? Colors.white, fontSize: 16)),
      ),
    );
  }
}
