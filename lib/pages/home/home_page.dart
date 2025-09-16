import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/photo_listview.dart';
import 'package:project_kotrip/data/service/place_code_map.dart';
import 'package:project_kotrip/pages/home/widgets/ai_btn.dart';
import 'package:project_kotrip/pages/home/widgets/home_photo_slide.dart';
import 'package:project_kotrip/pages/home/widgets/weather.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final random = Random();
    final keys = placeCodeMap.keys.toList();
    final randomKey = keys[random.nextInt(keys.length)];
    final code = placeCodeMap[randomKey]!;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text('이번엔', style: AppTxtSt.titleSt),
              Text(' 어디로', style: AppTxtSt.titleStB),
              Text(' 갈까요?', style: AppTxtSt.titleSt),
            ],
          ),
        ),
        HomePhotoSlide(),
        AiBtn(),
        PhotoListview(boldTitle: '이런곳', title: '은 어떨까요?', code: code),
        Weather(),
      ],
    );
  }
}