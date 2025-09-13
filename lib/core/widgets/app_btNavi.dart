import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/widgets/app_bar.dart';
import 'package:project_kotrip/pages/home/home_page.dart';
import 'package:project_kotrip/pages/my/my_page.dart';
import 'package:project_kotrip/pages/place/place_page.dart';
import 'package:project_kotrip/pages/plan/plan_intro_page.dart';

class AppBtNavi extends StatefulWidget {
  const AppBtNavi({super.key});

  @override
  State<AppBtNavi> createState() => _AppBtNaviState();
}

class _AppBtNaviState extends State<AppBtNavi> {
  int thisIndex = 0;

  // 페이지 리스트
  static final List<Widget> pages = <Widget>[
    HomePage(),
    PlanIntroPage(),
    PlacePage(),
    MyPage(),
  ];

  //탭을 눌렀을때 호출되는 함수
  void btnTap(int index) {
    setState(() {
      thisIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      body: pages[thisIndex],
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: thisIndex,
      onTap: btnTap,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: 48,
            height: 48,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colSecond,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Image.asset('assets/images/icon_home.png', width: 24, height: 24)),
            activeIcon: Container(
            width: 48,
            height: 48,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colSecond,
              borderRadius: BorderRadius.circular(48),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(73, 175, 116, 0.35),
                  blurRadius: 8,
                  offset: Offset(4, 4)
                )
              ]
            ),
            child: Image.asset('assets/images/icon_home.png', width: 24, height: 24)),
            label: '', 
        ),
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_menu_calendar.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/images/icon_menu_calendar_on.png', width: 24, height: 24),
            label: '', 
        ),
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_menu_location.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/images/icon_menu_location_on.png', width: 24, height: 24),
            label: '', 
        ),
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_menu_my.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/images/icon_menu_my_on.png', width: 24, height: 24),
            label: '', 
        ),
      ],
    ),
    );
  }
}
