// import 'package:flutter/material.dart';
// import 'package:project_kotrip/core/theme/colors.dart';
// import 'package:project_kotrip/core/theme/text_style.dart';

// class PlaceFilterItem extends StatefulWidget {
//   String title;
//   int index;
//   bool isSelectd;
//   PlaceFilterItem({
//     super.key,
//     required this.title,
//     required this.index,
//     this.isSelectd = false,
//   });

//   @override
//   State<PlaceFilterItem> createState() => _PlaceFilterItemState();
// }

// class _PlaceFilterItemState extends State<PlaceFilterItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
          
//         },
//         child: Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: widget.isSelectd ? colBkTxt : colGreyBg,
//           ),
//           child: Center(
//             child: Text(
//               widget.title,
//               style: widget.isSelectd
//                   ? AppTxtSt.txtStRB.copyWith(color: Colors.white)
//                   : AppTxtSt.txtStR,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
