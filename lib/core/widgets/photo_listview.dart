import 'package:flutter/material.dart';
import 'package:project_kotrip/core/theme/text_style.dart';

class PhotoListview extends StatelessWidget {
  String? boldTitle;
  String title;
  PhotoListview({super.key, this.boldTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (boldTitle != null)
                    Text(
                      boldTitle!,
                      style: TextStyles.titleSt.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  Text(title, style: TextStyles.titleSt),
                ],
              ),
              GestureDetector(
                onTap: () {},
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
              itemCount: 10,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
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
                          child: Image.asset(
                            'assets/images/img_jeju.png',
                            fit: BoxFit.cover,
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
                          Text('섭지코지', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          SizedBox(height: 6,),
                          Text('제주 서귀포시 성산읍 고성리제주 서귀포시 성산읍 고성리', style: TextStyle(color: Colors.white, fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis,)
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
