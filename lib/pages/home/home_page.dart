import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/place/widgets/photo_listview.dart';
import 'package:project_kotrip/pages/home/data/place_code_map.dart';
import 'package:project_kotrip/pages/home/widgets/ai_btn.dart';
import 'package:project_kotrip/pages/home/widgets/home_photo_slide.dart';
import 'package:project_kotrip/pages/home/widgets/weather_widget.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //페이지 접속할때마다 랜덤한 관광지 표출
  late final Random random;
  late final List<String> keys;
  late final String randomKey;
  late final String code;

  @override
  void initState() {
    super.initState();
    random = Random();
    keys = placeCodeMap.keys.toList();
    randomKey = keys[random.nextInt(keys.length)];
    code = placeCodeMap[randomKey]!;
  }

  @override
  Widget build(BuildContext context) {
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
        WeatherWidget(),
      ],
    );
  }
}