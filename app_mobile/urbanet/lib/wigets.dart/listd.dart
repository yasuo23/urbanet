// import 'package:flutter/material.dart';
// import 'package:urbanet/wigets.dart/type.dart';
// import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';

// class HorizontalScrollableList extends StatelessWidget {
//   final List<Map<String, dynamic>> data;

//   HorizontalScrollableList({Key? key, required this.data}) : super(key: key);
//   final _scrollController = FixedExtentScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 250,
//       child: ListWheelScrollViewX(
//         scrollDirection: Axis.horizontal,
//         offAxisFraction: -0.5,
//         itemExtent: 200,
//         diameterRatio: 5,
//         // controller: _scrollController,
//         children: List.generate(
//             data.length,
//             (index) => type(
//                 image: data[index]['image'],
//                 title: data[index]['title'],
//                 typeS: data[index]['typeS'],
//                 // func: data[index]['func'],
//                 col: data[index]['color'])
//             // [
//             //   // for (final item in data)
//             //   type(
//             //     image: 'images/pothole.png',
//             //     title: 'nid de poule  ',
//             //     typeS: 'pothole',
//             //   ),
//             // ],
//             ),
//       ),
//     );
//   }
// }
