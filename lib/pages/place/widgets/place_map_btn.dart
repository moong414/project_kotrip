
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/pages/place/view_model/review_view_model.dart';

class PlaceMapBtn extends ConsumerWidget {
  final String placeId;
  final String placeName;
  const PlaceMapBtn({
    super.key,
    required this.placeId,
    required this.placeName
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateFunc = ref.read(reviewViewModelProvider.notifier);

    return GestureDetector(
      onTap: () async{
        //지도로 열기
        await stateFunc.openGoogleMap(placeId, placeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colGrBg,
          ),
          padding: EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('지도로 보기', style: AppTxtSt.txtStL,),
              Container(
                width: 56,
                height: 52,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/icon_map.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}