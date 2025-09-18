// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class HomePhotoSlide extends StatefulWidget {
//   const HomePhotoSlide({super.key});

//   @override
//   State<HomePhotoSlide> createState() => _HomePhotoSlideState();
// }

// class _HomePhotoSlideState extends State<HomePhotoSlide> {
//   late int thisPage;

//   @override
//   void initState() {
//     super.initState();
//     thisPage = 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 90,
//       child: CarouselSlider(
//         options: CarouselOptions(
//           autoPlay: true,
//           onPageChanged: (index, reason) {
//             setState(() {
//               thisPage = index;
//             });
//           },
//         ),
//         items: [1, 2, 3, 4, 5].map((i) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: thisPage == (i - 1) ? Colors.black : Colors.white,
//                   borderRadius: BorderRadius.circular(10)
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Opacity(
//                       opacity: thisPage == (i - 1) ? 0.8 :0.6,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(
//                           'assets/images/img_pusan.png',
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       '$i 부산?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
