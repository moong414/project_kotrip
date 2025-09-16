import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/photo_listview.dart';
import 'package:project_kotrip/data/service/place_code_map.dart';
import 'package:project_kotrip/pages/place/place_view_model.dart';
import 'package:project_kotrip/pages/place/widgets/place_filter_item.dart';

class PlacePage extends ConsumerStatefulWidget {
  const PlacePage({super.key});

  @override
  ConsumerState<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends ConsumerState<PlacePage> {
  final placeBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colSecond, width: 1),
    borderRadius: BorderRadius.circular(10),
  );
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showPlacePicker() {
    String pickedCode = placeCodeMap.values.first;
    List<String> placeList = placeCodeMap.keys.toList();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 260,
          color: Colors.white,
          child: Column(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text('완료'),
                onPressed: () {
                  final entry = placeCodeMap.entries.firstWhere((element) {
                    return element.value == pickedCode;
                  });
                  final selectedName = entry.key;
                  final selectedCode = entry.value;

                  setState(() {
                    controller.text = selectedName;
                  });

                  ref
                      .read(placeViewModelProvider.notifier)
                      .loadPlaces(areaCode: selectedCode);

                  Navigator.of(context).pop();
                },
              ),
              const Divider(height: 1, color: colGreyBtn),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    final name = placeList[index];
                    pickedCode = placeCodeMap[name]!;
                  },
                  children: placeList.map((e) {
                    return Center(child: Text(e));
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placeViewModelProvider);
    final thisPlace = placeCodeMap.entries.firstWhere((element) {
      return element.value == state.areaCode;
    },).key;

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
                        hintText: thisPlace ?? '지역을 선택하세요',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 52,
                        height: 52,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: showPlacePicker,
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
          PhotoListview(title: '관광지', contentTypeId: '12'),
          PhotoListview(title: '문화시설', contentTypeId: '14'),
          PhotoListview(title: '음식', contentTypeId: '39'),
        ],
      ),
    );
  }
}
