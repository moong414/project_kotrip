
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class TutorialSection extends StatelessWidget {
  final String title;
  final String txt;
  final String img;
  final String btnTxt;
  final VoidCallback onNext;

  const TutorialSection({
    super.key,
    required this.title,
    required this.txt,
    required this.img,
    required this.btnTxt,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(title, style: AppTxtSt.titleStL),
            const SizedBox(height: 20),
            Text(txt, style: AppTxtSt.txtStR, textAlign: TextAlign.center),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(img, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(
                  backgroundColor: colPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  btnTxt,
                  style: AppTxtSt.txtStL.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
