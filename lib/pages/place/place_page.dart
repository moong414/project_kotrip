import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/photo_listview.dart';
import 'package:project_kotrip/pages/place/widgets/place_filter_item.dart';

class PlacePage extends StatelessWidget {
  PlacePage({super.key});

  final placeBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colSecond, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('이런곳', style: AppTxtSt.titleStB),
                    Text('은 어떨까요?', style: AppTxtSt.titleSt),
                  ],
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    TextFormField(
                      controller: controller,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        border: placeBorder,
                        enabledBorder: placeBorder,
                        focusedBorder: placeBorder,
                        disabledBorder: placeBorder,
                        hintText: '제주도',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 52,
                        height: 52,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            //위치변경
                          },
                          icon: Image.asset(
                            'assets/images/icon_menu_location_on.png',
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    PlaceFilterItem(title: '전체', isSelectd: true),
                    SizedBox(width: 10),
                    PlaceFilterItem(title: '관광지'),
                    SizedBox(width: 10),
                    PlaceFilterItem(title: '문화시설'),
                    SizedBox(width: 10),
                    PlaceFilterItem(title: '음식'),
                  ],
                ),
              ],
            ),
          ),
          PhotoListview(title: '관광지'),
          PhotoListview(title: '문화시설'),
          PhotoListview(title: '음식'),
        ],
      ),
    );
  }
}
