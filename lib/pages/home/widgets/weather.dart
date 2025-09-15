import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class Weather extends StatelessWidget {
  const Weather({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(border: BoxBorder.all(color: colGreyBtn), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(children: [
            Image.asset('assets/images/icon_weather01.png', width: 32,), 
            SizedBox(width: 13,),
            Text('29', style: TextStyle(fontSize: 18),),
            SizedBox(width: 4,),
            Text('℃', style: TextStyle(fontWeight: FontWeight.w300),)
          ],),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text('서울의 날씨'),
            Text('2025. 09. 01', style: AppTxtSt.txtStL),
          ],)
        ],),
      ),
    );
  }
}
