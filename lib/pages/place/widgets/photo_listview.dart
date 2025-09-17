import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/text_style.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/pages/place/place_detail_page.dart';
import 'package:project_kotrip/pages/place/place_view_model.dart';

class PhotoListview extends ConsumerStatefulWidget {
  String? boldTitle;
  String title;
  String? code;
  String kindPlace;
  PhotoListview({
    super.key,
    this.boldTitle,
    required this.title,
    this.code,
    this.kindPlace = 'tourPlaceList',
  });

  @override
  ConsumerState<PhotoListview> createState() => _PhotoListviewState();
}

class _PhotoListviewState extends ConsumerState<PhotoListview> {
  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      ref.read(placeViewModelProvider.notifier).loadPlaces(areaCode: widget.code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placeViewModelProvider).funcPlaceList(widget.kindPlace.toString());
    
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (widget.boldTitle != null)
                    Text(widget.boldTitle!, style: AppTxtSt.titleStB),
                  Text(widget.title, style: AppTxtSt.titleSt),
                ],
              ),
              widget.code == null
                  ? Padding(padding: const EdgeInsets.all(32))
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppBtNavi(initialIndex: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/icon_go_arrow.png',
                          width: 24,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PlaceDetailPage(placemodel: state[index]);
                        },));
                      },
                      child: Container(
                        width: 160,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.network(
                              state[index].firstimage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 14,
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 14),
                          SizedBox(width: 3),
                          Text('4.6', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state[index].title,
                            style: AppTxtSt.txtStRBWt,
                          ),
                          SizedBox(height: 6),
                          Text(
                            state[index].addr,
                            style: AppTxtSt.txtStSWt,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 15);
              },
            ),
          ),
        ],
      ),
    );
  }
}
