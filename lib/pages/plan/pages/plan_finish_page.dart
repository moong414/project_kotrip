import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/app_button.dart';
import 'package:project_kotrip/pages/plan/data/plan_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_finish_item_widget.dart';

class PlanFinishPage extends StatefulWidget {
  const PlanFinishPage({super.key});

  @override
  State<PlanFinishPage> createState() => _PlanFinishPageState();
}

class _PlanFinishPageState extends State<PlanFinishPage> {
  // 임시 리스트
  List<PlanModel> PlanModels = [
    PlanModel(time: '08:15', place: '제주공항', todo: '서울 출발 → 제주 도착. 렌터카 수령'),
    PlanModel(time: '08:30', place: '제주공항', todo: '제주 공항 근처에서 아침식사 (고기국수)'),
    PlanModel(time: '12:00', todo: '점심: 흑돼지 근고기 구이'),
    PlanModel(time: '14:00', place: '한림공원', todo: '한림공원 (사진 포인트 + 산책)'),
    PlanModel(time: '16:00', place: '오설록 티뮤지엄', todo: '오설록 티뮤지엄 & 인근 녹차밭'),
    PlanModel(time: '18:00', todo: '저녁: 해산물 뷔페나 회정식'),
    PlanModel(time: '20:00', place: '제주가고싶다호텔', todo: '숙소 체크인'),
  ];
  List<PlanModel> PlanModels2 = [
    PlanModel(
      time: '07:30',
      place: '숙소근처 카페',
      todo: '숙소 근처 카페에서 아침 (바다 뷰 카페 강추)',
    ),
    PlanModel(
      time: '09:00',
      place: '한라산',
      todo: '한라산 어리목 코스 (가볍게 2~3시간 트래킹) → 힘들면 대신 에코랜드 산책 코스로 변경 가능',
    ),
    PlanModel(time: '12:00', todo: '점심: 갈치조림 or 전복돌솥밥'),
    PlanModel(time: '14:00', todo: '성산일출봉 근처 → 우도 뷰 즐기기'),
    PlanModel(time: '16:00', place: '섭지코지', todo: '섭지코지 드라이브 & 산책'),
    PlanModel(time: '18:00', place: '제주공항', todo: '저녁: 공항 근처 고기국수 / 김밥 간단히'),
    PlanModel(time: '20:00', place: '제주공항', todo: '제주 출발 → 서울 도착'),
  ];

  List get planlist => [PlanModels, PlanModels2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
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
                        Text('제주도', style: AppTxtSt.titleStB),
                        SizedBox(width: 8),
                        Text('25.09.27 - 25.09.28', style: AppTxtSt.txtStL),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colPrimary,
                        ),
                        child: Center(
                          child: Text(
                            'Day 1',
                            style: AppTxtSt.txtStL.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 12);
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Text('Day1', style: AppTxtSt.txtStLB),
                            SizedBox(width: 4),
                            Text('(25. 09 .26)'),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: PlanModels.length,
                        itemBuilder: (context, index) {
                          return PlanFinishItemWidget(
                            index: index,
                            listLen: PlanModels.length,
                            item: PlanModels[index],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Text('Day2', style: AppTxtSt.txtStLB),
                            SizedBox(width: 4),
                            Text('(25. 09 .27)'),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: PlanModels.length,
                        itemBuilder: (context, index) {
                          return PlanFinishItemWidget(
                            index: index,
                            listLen: PlanModels.length,
                            item: PlanModels[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 72,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        bgColor: colRedBtn,
                        text: '삭제',
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
