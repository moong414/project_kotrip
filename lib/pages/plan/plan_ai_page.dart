import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/core/widgets/loading_widget.dart';
import 'package:project_kotrip/pages/plan/plan_finish_page.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_text_form.dart';
import 'package:project_kotrip/pages/plan/widgets/plan_top_info.dart';

class PlanAiPage extends ConsumerStatefulWidget {
  const PlanAiPage({super.key});

  @override
  ConsumerState<PlanAiPage> createState() => _PlanAiPageState();
}

class _PlanAiPageState extends ConsumerState<PlanAiPage> {
  bool isLoading = false;
  late TextEditingController themeController;

  List<String> themeList = [
    '뚜벅이',
    '나홀로',
    '여유롭게',
    '액티비티',
    '휴식',
    '역사탐방',
    '미식',
    '사진',
    '자연/경치',
    '도시',
    '문화예술',
    '쇼핑',
  ];
  //전달할 테마목록
  Set<String> themeSet = {};

  @override
  void initState() {
    super.initState();
    themeSet = {}; //테마목록초기화
    themeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planViewModelProvider);
    final planFunc = ref.read(planViewModelProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          appBar: BasicAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //상단정보
                  PlanTopInfo(
                    planState: planState,
                    startDate: planState.startFormat,
                    endDate: planState.endFormat,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colGrBg,
                    ),
                    child: Text(
                      '어떤 여행을 선호하세요?',
                      style: AppTxtSt.txtStL,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text('여행 테마', style: AppTxtSt.titleSt),
                  SizedBox(height: 20),
                  PlanTextForm(
                    hintText: '자유롭게 입력하세요',
                    controller: themeController,
                  ),
                  SizedBox(height: 20),
                  Text('여행 키워드', style: AppTxtSt.titleSt),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 30),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(themeList.length, (index) {
                        final item = themeList[index];
                        final isSelected = themeSet.contains(item);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                themeSet.remove(item);
                              } else {
                                themeSet.add(item);
                              }
                            });
                          },
                          child: Container(
                            width:
                                ((MediaQuery.of(context).size.width) / 4) - 16,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: isSelected ? colGreenAi : colGreyBg,
                            ),
                            child: Center(
                              child: Text(
                                themeList[index],
                                style: isSelected
                                    ? AppTxtSt.txtStRB.copyWith(
                                        color: Colors.white,
                                      )
                                    : AppTxtSt.txtStR,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colGreenAi, colMintAi]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await planFunc.geminiCreatePlan(
                          themeController.text,
                          themeSet,
                        );
                        setState(() {
                          isLoading = false; // 로딩 끝
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlanFinishPage();
                            },
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(16, 17, 16, 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icon_ai_wt.png',
                            width: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'AI에게 부탁하기',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) LoadingWidget(message: 'AI가 여행계획을 완성하는중...'),
      ],
    );
  }
}
