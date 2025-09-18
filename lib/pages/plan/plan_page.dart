import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/data/model/plan_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_dialog.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_item_widget.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  // 임시 리스트
  List<PlanModel> planItems = [
    PlanModel(time: '08:15', place: '제주공항', todo: '서울 출발 → 제주 도착. 렌터카 수령'),
    PlanModel(time: '08:30', place: '제주공항', todo: '제주 공항 근처에서 아침식사 (고기국수)'),
    PlanModel(time: '12:00', place: '제주공항', todo: '점심: 흑돼지 근고기 구이'),
    PlanModel(time: '14:00', place: '제주공항', todo: '한림공원 (사진 포인트 + 산책)'),
    PlanModel(time: '16:00', place: '오설록 티뮤지엄', todo: '오설록 티뮤지엄 & 인근 녹차밭'),
    PlanModel(time: '18:00',  todo: '저녁: 해산물 뷔페나 회정식'),
    PlanModel(time: '20:00', place: '제주가고싶다호텔', todo: '숙소 체크인'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      floatingActionButton: PlanDialog(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '제주도',
                          style: AppTxtSt.titleStB
                        ),
                        SizedBox(width: 8),
                        Text('25.09.27 - 25.09.28', style: AppTxtSt.txtStL),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: colGreyBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 56, height: 56),
                          Row(
                            children: [
                              Text(
                                'Day 1 ',
                                style: AppTxtSt.txtStLB
                              ),
                              Text('25. 09. 27', style: AppTxtSt.txtStR),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              print('클릭!');
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/images/icon_go_arrow.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              (planItems.isEmpty) ?
              Expanded(child: Center(child: Text('일정을 추가해보세요!', style: AppTxtSt.txtStL.copyWith(color: Color(0xff999999)),),))
              : Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: planItems.length,
                  itemBuilder: (context, index) {
                    final item = index;
                    return PlanItemWidget(
                      key: ValueKey(item),
                      index: index,
                      listLen: planItems.length,
                      item: planItems[index],
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = planItems.removeAt(oldIndex);
                    planItems.insert(newIndex, item);
                  },
                ),
              ),
              Container(
                height: 72,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        bgColor: colGreyBtn,
                        txtColor: colBkTxt,
                        text: '취소',
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        bgColor: colBkBtn,
                        text: '저장',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

