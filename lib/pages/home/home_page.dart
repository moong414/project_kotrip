import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bar.dart';
import 'package:project_kotrip/core/widgets/photo_listview.dart';
import 'package:project_kotrip/pages/home/widgets/ai_btn.dart';
import 'package:project_kotrip/pages/home/widgets/home_photo_slide.dart';
import 'package:project_kotrip/pages/home/widgets/weather.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text('이번엔', style: TextStyles.titleSt),
                Text(
                  '어디로',
                  style: TextStyles.titleSt.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text('갈까요?', style: TextStyles.titleSt),
              ],
            ),
          ),
          HomePhotoSlide(),
          AiBtn(),
          PhotoListview(boldTitle: '이런곳', title: '은 어떨까요?',),
          Weather(),
        ],
      ),
    );
  }
}
