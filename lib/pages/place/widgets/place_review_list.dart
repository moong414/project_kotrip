import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/place/data/review_model.dart';

class PlaceReviewList extends StatelessWidget {
  List<Review> reviewList;
  PlaceReviewList({super.key, required this.reviewList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reviewList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: BoxBorder.all(color: colGreyBtn),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewList[index].text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTxtSt.txtStR,
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        reviewList[index].authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat('yy-MM-dd').format(reviewList[index].time),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 15);
        },
      ),
    );
  }
}
