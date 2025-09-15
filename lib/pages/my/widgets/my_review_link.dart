import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class MyReviewLink extends StatelessWidget {
  const MyReviewLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: BoxBorder.all(color: colGreyBtn),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('제주도', style: AppTxtSt.txtStL),
                    Text('25. 09. 07', style: AppTxtSt.txtStR),
                  ],
                ),
                SizedBox(height: 4),
                Text('교통이 불편하지만 가볼 만 함', style: AppTxtSt.txtStR),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/icon_go_arrow.png', width: 24),
            ),
          ],
        ),
      ),
    );
  }
}
