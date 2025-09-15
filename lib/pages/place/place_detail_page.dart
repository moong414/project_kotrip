import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/pages/place/model/review_model.dart';
import 'package:project_kotrip/pages/place/widgets/place_map_btn.dart';
import 'package:project_kotrip/pages/place/widgets/my_review_dialog.dart';
import 'package:project_kotrip/pages/place/widgets/place_review_list.dart';

class PlaceDetailPage extends StatelessWidget {
  PlaceDetailPage({super.key});

  final placeBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colSecond, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  //리뷰리스트
  List<ReviewModel> reviewList = [
    ReviewModel(author: '김땡땡', content: '성산일출봉은 제주도 여행 중 꼭 들러야 할 명소입니다.', date: '25.09.09'),
    ReviewModel(author: '임땡땡', content: '성산일출봉은 제주도 여행 중 꼭 들러야 할 명소입니다.', date: '25.09.09'),
    ReviewModel(author: '문땡땡', content: '성산일출봉은 제주도 여행 중 꼭 들러야 할 명소입니다.', date: '25.09.09')
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 490,
            child: Image.asset(
              'assets/images/img_jeju.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 380,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('제주루루룰루', style: AppTxtSt.titleStWtB),
                  SizedBox(height: 5),
                  Text(
                    '제주의 어딘가제주의 어딘가제주의 어딘가제주의 어딘가제주의 어딘가',
                    style: AppTxtSt.txtStRWt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(width: double.infinity, height: 470),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Text('장소 리뷰', style: AppTxtSt.txtStL),
                          SizedBox(width: 10),
                          Icon(Icons.star, color: colPrimary, size: 18),
                          SizedBox(width: 4),
                          Text('4.6', style: AppTxtSt.txtPrimary),
                        ],
                      ),
                    ),
                    PlaceReviewList(reviewList: reviewList,),
                    PlaceMapBtn(),
                    MyReviewDialog(),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: SizedBox(height: 70, child: BasicAppBar(darkMode: true)),
            ),
          ),
        ],
      ),
    );
  }
}

