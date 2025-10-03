import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/pages/home/data/place_code_map.dart';

class HomePhotoSlide extends StatefulWidget {
  const HomePhotoSlide({super.key});

  @override
  State<HomePhotoSlide> createState() => _HomePhotoSlideState();
}

class _HomePhotoSlideState extends State<HomePhotoSlide> {
  late int thisPage;
  final List<MapEntry<String, String>> placeList = placeCodeMap.entries.toList();

  @override
  void initState() {
    super.initState();
    thisPage = 0;
    placeList.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              thisPage = index;
            });
          },
        ),
        items: placeList.asMap().entries.map((entry) {
          int i = entry.key;
          String region = entry.value.key;
          String code = entry.value.value;

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AppBtNavi(initialIndex: 1, title: region);
                  },));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: thisPage == i ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: thisPage == i ? 0.8 : 0.6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/img_$code.png', // 코드 기반 이미지
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Text(
                        '$region?', // 지역명 표시
                        style: AppTxtSt.txtStLWt
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
