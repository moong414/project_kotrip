import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/home/data/place_code_map.dart';
import 'package:project_kotrip/pages/home/widgets/ai_btn.dart';
import 'package:project_kotrip/pages/home/widgets/home_photo_slide.dart';
import 'package:project_kotrip/pages/home/widgets/weather_widget.dart';
import 'package:project_kotrip/pages/place/view_model/place_view_model.dart';
import 'package:project_kotrip/pages/place/widgets/photo_listview.dart';

class HomePage extends ConsumerStatefulWidget{
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //페이지 접속할때마다 랜덤한 관광지 표출
  late final Random random;
  late final List<String> keys;
  late final String randomKey;
  late final String code;
  //데이터통신 확인용
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    random = Random();
    keys = placeCodeMap.keys.toList();
    randomKey = keys[random.nextInt(keys.length)];
    code = placeCodeMap[randomKey]!;
    // 데이터 통신 확인용
    checkTourData();
  }

  // 데이터 통신 확인용
  Future<void> checkTourData() async {
    final success = await ref.read(placeViewModelProvider.notifier).pingTourApi(areaCode: code);
    setState(() {
      hasData = success;
    });
  }

  //새로고침
  Future<void> refreshData() async {
    setState(() {
      randomKey = keys[random.nextInt(keys.length)];
      code = placeCodeMap[randomKey]!;
      hasData = false;
    });
    //다시한번 데이터통신 확인하기
    final success = await ref.read(placeViewModelProvider.notifier).pingTourApi(areaCode: code);
    setState(() {
      hasData = success;
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView(
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
          if(hasData)
          PhotoListview(boldTitle: '이런곳', title: '은 어떨까요?', code: code),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text('오늘의 날씨', style: AppTxtSt.titleSt),
              ],
            ),
          ),
          WeatherWidget(),
        ],
      ),
    );
  }
}