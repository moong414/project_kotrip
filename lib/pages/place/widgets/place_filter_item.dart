
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PlaceFilterItem extends StatelessWidget {
  bool isSelectd;
  String title;
  PlaceFilterItem({
    super.key,
    this.isSelectd = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: isSelectd ? colBkTxt : colGreyBg),
      child: Center(child: Text(title, style: isSelectd ? AppTxtSt.txtStRB.copyWith(color: Colors.white) : AppTxtSt.txtStR)),
    ));
  }
}
