import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';

class AppIconButton extends StatelessWidget {
  final double? width;
  final Color? bgColor;
  final VoidCallback? onPressed;
  final Image? img;
  final Icon? icon;

  const AppIconButton({
    super.key,
    this.width,
    this.bgColor,
    required this.onPressed,
    this.img,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 56,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: bgColor ?? colPrimary,
          ),
          child: img ?? (icon ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
