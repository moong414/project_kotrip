import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/home/view_model/weather_view_model.dart';

class WeatherWidget extends ConsumerStatefulWidget {
  const WeatherWidget({super.key});

  @override
  ConsumerState<WeatherWidget> createState() => _WeatherState();
}

class _WeatherState extends ConsumerState<WeatherWidget> {

  @override
  void initState() {
    super.initState();
    // fetchInitialData();
  }

  //날씨정보 불러오기
  // Future<void> fetchInitialData() async {
  //   final userState = ref.read(userViewModelProvider);
  //   if (userState.user?.address != '주소가 없습니다.') {
  //     final kakaorepo = KakaoRepository();
  //     final address = await kakaorepo.getAddress(userState.user!.address);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    print('weatherState!! $weatherState===========================================');

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
