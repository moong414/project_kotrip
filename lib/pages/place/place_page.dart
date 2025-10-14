import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/pages/place/widgets/photo_listview.dart';
import 'package:project_kotrip/pages/home/data/place_code_map.dart';
import 'package:project_kotrip/pages/place/view_model/place_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final ItemScrollController itemScrollController = ItemScrollController();
  int? btnIndex = 0; //스크롤버튼용

  //장소변경버튼
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

                  ref.read(placeViewModelProvider.notifier).loadPlaces(areaCode: selectedCode);

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

  //리스트
  List<String> placeTitList = ['관광지', '문화시설', '음식', '쇼핑'];
  List<String> kindList = [
    'tourPlaceList',
    'culturePlaceList',
    'foodPlaceList',
    'etcPlaceList',
  ];
  //클릭시 이동
  void scrollToPlan(int index) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placeViewModelProvider);

    final thisPlace = placeCodeMap.entries.firstWhere(
      (element) => element.value == state.areaCode,
      orElse: () => placeCodeMap.entries.first,
    ).key;

    return Scaffold(
      appBar: BasicAppBar(),
      body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('이런곳', style: AppTxtSt.titleStB),
                    Text('은 어떨까요?', style: AppTxtSt.titleSt),
                  ],
                ),
                SizedBox(height: 20),
                //장소변경버튼
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
                        hintText: thisPlace,
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
                    for (int i = 0; i < placeTitList.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //클릭시 이동
                            scrollToPlan(i);
                            setState(() {
                              btnIndex = i;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: btnIndex == i ? colBkTxt : colGreyBg,
                            ),
                            child: Center(
                              child: Text(
                                placeTitList[i],
                                style: btnIndex == i
                                    ? AppTxtSt.txtStRB.copyWith(
                                        color: Colors.white,
                                      )
                                    : AppTxtSt.txtStR,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return PhotoListview(
                    title: placeTitList[index],
                    kindPlace: kindList[index],
                  );
                },
              ),
          ),
        ],
      ),
    ),
    );
  }
}
