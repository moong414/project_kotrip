import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/pages/home/view_model/weather_view_model.dart';
import 'package:project_kotrip/pages/my/view_model/user_view_model.dart';
import 'package:project_kotrip/pages/my/data/kakao_repository.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class WeatherWidget extends ConsumerStatefulWidget {
  const WeatherWidget({super.key});

  @override
  ConsumerState<WeatherWidget> createState() => _WeatherState();
}

class _WeatherState extends ConsumerState<WeatherWidget> {
  bool isLoading = false;
  bool hasFetched = false;

  @override
  void initState() {
    super.initState();
    fetchDataOnce();
  }

  //날씨 한번만 불러오기
  Future<void> fetchDataOnce() async {
    if (hasFetched) return;
    hasFetched = true;
    await fetchData();
  }

  //주소, 날씨불러오기
  Future<void> fetchData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final userVm = ref.read(userViewModelProvider);
      double latitude = 37.5511694;
      double longitude = 126.9882266;

      // 카카오 API로 좌표 가져오기
      if (userVm.user?.address != null &&
          userVm.user!.address.trim().isNotEmpty &&
          userVm.user!.address != '주소가 없습니다.') {
        final kakaorepo = KakaoRepository();
        final location = await kakaorepo.getAddress(userVm.user!.address);
        if (location.isNotEmpty) {
          latitude = double.parse(location.first.mapY);
          longitude = double.parse(location.first.mapX);
        }
      }

      await ref.read(weatherProvider.notifier).fetchWeather(latitude, longitude);
    } catch (e, st) {
      print('WeatherWidget fetchData error: $e\n$st');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // 새로고침함수
  Future<void> refreshData() async {
    hasFetched = false;
    await fetchDataOnce();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    final weatherState = ref.watch(weatherProvider);
    final temperature = weatherState?.temperature.toStringAsFixed(1) ?? '-';
    final rain = weatherState?.rain.toStringAsFixed(0) ?? '-';
    final displayAddress = (userState.user?.address == null || userState.user!.address.trim().isEmpty || userState.user!.address == '주소가 없습니다.')? '서울의 날씨': userState.user!.address;

    return Column(
      children: [
        isLoading
            ? LoadingWidget(isPart: true)
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colGreyBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 6, 6, 19),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_location.png',
                              width: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              displayAddress,
                              style: AppTxtSt.txtStR,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 18, 15, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_weather_${weatherState?.sky ?? 'default'}.png',
                                        width: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '$temperature℃',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_clock.png',
                                        width: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        weatherState != null
                                            ? DateFormat(
                                                'yy.MM.dd(HH:mm)',
                                              ).format(weatherState.time)
                                            : '-',
                                        style: AppTxtSt.txtStR,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: colGreyBg),
                            Padding(
                              padding: const EdgeInsets.only(left: 18, bottom: 7),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_umbrella.png',
                                        width: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text('강수확률', style: AppTxtSt.txtStS),
                                      SizedBox(width: 2),
                                      Text('$rain%', style: AppTxtSt.txtStR),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: refreshData,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4), 
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Row(
                                      children: [
                                        Text('새로고침', style: AppTxtSt.txtStS),
                                        SizedBox(width: 4),
                                        Image.asset(
                                          'assets/images/icon_refresh.png',
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
