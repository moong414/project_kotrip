
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PlaceMapBtn extends StatelessWidget {
  const PlaceMapBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        //Todo!지도로 열기
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
          
        // },));
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colGrBg,
          ),
          padding: EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('지도로 보기', style: AppTxtSt.txtStL,),
              Container(
                width: 56,
                height: 52,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/icon_map.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}