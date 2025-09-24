import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/basic_app_bar.dart';
import 'package:project_kotrip/pages/place/data/place_model.dart';
import 'package:project_kotrip/pages/place/view_model/review_view_model.dart';
import 'package:project_kotrip/pages/place/widgets/place_map_btn.dart';
import 'package:project_kotrip/pages/place/widgets/place_review_list.dart';

class PlaceDetailPage extends ConsumerStatefulWidget {
  PlaceModel placemodel;
  String placeName;

  PlaceDetailPage({super.key, required this.placemodel, required this.placeName});

  @override
  ConsumerState<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends ConsumerState<PlaceDetailPage> {
  final placeBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colSecond, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  void initState() {
    super.initState();
    ref.read(reviewViewModelProvider.notifier).loadReview(place: widget.placemodel);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 490,
            child: Opacity(
              opacity: 0.9,
              child: Image.network(
                widget.placemodel.firstimage,
                fit: BoxFit.cover,
              ),
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
                  Text(widget.placemodel.title, style: AppTxtSt.titleStWtB),
                  SizedBox(height: 5),
                  Text(
                    widget.placemodel.addr,
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
                          Text(
                            '${state.reviewModel.rating}',
                            style: AppTxtSt.txtPrimary,
                          ),
                        ],
                      ),
                    ),
                    (state.reviewModel.reviews.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: colGreyBtn),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '장소리뷰가 없습니다.',
                                style: AppTxtSt.hintStR,
                              ),
                            ),
                          )
                        : PlaceReviewList(
                            reviewList: state.reviewModel.reviews,
                          ),
                    PlaceMapBtn(placeId: state.placeId, placeName: widget.placeName,),
                    //Todo 리뷰
                    // MyReviewDialog(),
                    SizedBox(height: 30),
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
