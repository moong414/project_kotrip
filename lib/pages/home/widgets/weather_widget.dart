import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/home/view_model/weather_view_model.dart';
import 'package:project_kotrip/pages/my/data/kakao_repository.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';

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
  Future<void> fetchInitialData() async {
    final userVm = ref.read(userViewModelProvider);
    if (userVm.user?.address != '주소가 없습니다.') {
      final kakaorepo = KakaoRepository();
      final address = await kakaorepo.getAddress(userVm.user!.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    final weatherState = ref.watch(weatherProvider);
    print('weatherState!! $weatherState===========================================');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: BoxBorder.all(color: colGreyBtn), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(children: [
                  Image.asset('assets/images/icon_weather01.png', width: 32,), 
                  SizedBox(width: 10),
                  Text('29', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 4,),
                  Text('℃', style: TextStyle(fontWeight: FontWeight.w300),)
                ],),
                SizedBox(width: 4,),
                Expanded(child: Text(userState.user?.address ?? '서울시의 날씨', style: AppTxtSt.txtStR, textAlign: TextAlign.end,  overflow: TextOverflow.ellipsis,))
              ],),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(color: colGreyBg, borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Image.asset('assets/images/icon_umbrella.png', width: 16,),
                    SizedBox(width: 4,),
                    Text('0%', style: AppTxtSt.txtStR,)
                  ],),
                  Row(children: [
                    Image.asset('assets/images/icon_clock.png', width: 16,),
                    SizedBox(width: 4,),
                    Text('2025.09.01 (08:15)', style: AppTxtSt.txtStR,)
                  ],),
                ],),
            )
          ],
        ),
      ),
    );
  }
}
