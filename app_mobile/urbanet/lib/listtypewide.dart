// import 'package:flutter/material.dart';
// import 'package:urbanet/packag.dart/map2.dart';
// import 'package:urbanet/wigets.dart/type.dart';
// import 'package:urbanet/wigetpages.dart/signaler.dart';
// import 'package:urbanet/wigets.dart/listd.dart';
// import 'package:urbanet/packag.dart/photo.dart';
// import 'package:urbanet/itemliste.dart/liste.dart';
// import 'package:urbanet/packag.dart/video.dart';
// // import 'dart:core';

// class type extends StatelessWidget {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     listS i = listS();
//     List<Map<String, dynamic>> items = i.getList();
//     return Scaffold(
//       backgroundColor: Colors.blue[700],
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue[900],
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(36.0),
//                   bottomRight: Radius.circular(36.0),
//                   topLeft: Radius.circular(0),
//                   topRight: Radius.circular(0),
//                 ),
//               ),
//               height: 250,
//               width: 400,
//             ),
//             Row(children: [
//               // Image.asset(
//               //   'images/motorwat.png',
//               //   height: 20,
//               //   width: 20,
//               // ),
//               Text(
//                 'probleme de route ',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 239, 241, 243),
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.normal,
//                   fontFamily: 'Roboto',
//                 ),
//               )
//             // ]),
//             // HorizontalScrollableList(data: items),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => map2(
//                               // title: 'hi',
//                               // typeS: 't',
//                               // image: 'images/pothole.png',
//                               )));
//                 },
//                 child: Text('hi'))
//           ],
//         ),
//       ),
//     );
//   }
// }
// //  Container(
// //               height: 220,
// //               child: ListView(
// //                 scrollDirection: Axis.horizontal,
// //                 children: [
// //                   Column(
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.only(left: 20.0),
// //                         child: Stack(
// //                           children: [
// //                             Container(
// //                               height: 145,
// //                               width: 145,
// //                               decoration: BoxDecoration(
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Color.fromARGB(115, 19, 19, 19),
// //                                     offset: const Offset(
// //                                       5.0,
// //                                       0.0,
// //                                     ),
// //                                     blurRadius: 10.0,
// //                                     spreadRadius: 2.0,
// //                                   ),
// //                                 ],
// //                                 borderRadius: BorderRadius.only(
// //                                   topLeft: Radius.circular(5.0),
// //                                   topRight: Radius.circular(5.0),
// //                                   bottomLeft: Radius.circular(5.0),
// //                                   bottomRight: Radius.circular(5.0),
// //                                 ),
// //                                 image: DecorationImage(
// //                                   image: NetworkImage(
// //                                       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjukt4teaeAMPxKQaP0QviXk_zj0cTW0SVJPIr0fHAxRPIvhMjSNViBQghsQ6Nc4L1HEg&usqp=CAU"),
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                               /* add child content here */
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Container(
// //                                 padding: EdgeInsets.only(
// //                                     top: 8, bottom: 8, left: 12, right: 12),
// //                                 decoration: BoxDecoration(
// //                                   color: Color.fromARGB(255, 151, 99, 204)
// //                                       .withOpacity(0.9),
// //                                   borderRadius: BorderRadius.only(
// //                                     topLeft: Radius.circular(25.0),
// //                                     topRight: Radius.circular(25.0),
// //                                     bottomLeft: Radius.circular(25.0),
// //                                     bottomRight: Radius.circular(25.0),
// //                                   ),
// //                                 ),
// //                                 child: Row(
// //                                   children: [
// //                                     Icon(Icons.person,
// //                                         color: Colors.grey[300], size: 14),
// //                                     SizedBox(
// //                                       width: 5,
// //                                     ),
// //                                     Text(
// //                                       '189k',
// //                                       style: GoogleFonts.quicksand(
// //                                         color: Colors.white,
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Padding(
// //                           padding: const EdgeInsets.only(left: 15.0, top: 10),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 Icons.play_circle_outline,
// //                                 color: Colors.white,
// //                               ),
// //                               SizedBox(
// //                                 width: 5,
// //                               ),
// //                               Text('Watch Now',
// //                                   style: GoogleFonts.averageSans(
// //                                     color: Colors.white,
// //                                     fontSize: 14,
// //                                     letterSpacing: 1,
// //                                   )),
// //                             ],
// //                           )),
// //                     ],
// //                   ),
// //                   Column(
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.only(left: 20.0),
// //                         child: Stack(
// //                           children: [
// //                             Container(
// //                               height: 145,
// //                               width: 145,
// //                               decoration: BoxDecoration(
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Color.fromARGB(115, 19, 19, 19),
// //                                     offset: const Offset(
// //                                       5.0,
// //                                       0.0,
// //                                     ),
// //                                     blurRadius: 10.0,
// //                                     spreadRadius: 2.0,
// //                                   ),
// //                                 ],
// //                                 borderRadius: BorderRadius.only(
// //                                   topLeft: Radius.circular(5.0),
// //                                   topRight: Radius.circular(5.0),
// //                                   bottomLeft: Radius.circular(5.0),
// //                                   bottomRight: Radius.circular(5.0),
// //                                 ),
// //                                 image: DecorationImage(
// //                                   image: NetworkImage(
// //                                       "https://wallpaperaccess.com/full/1077356.jpg"),
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                               /* add child content here */
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Container(
// //                                 padding: EdgeInsets.only(
// //                                     top: 8, bottom: 8, left: 12, right: 12),
// //                                 decoration: BoxDecoration(
// //                                   color: Color.fromARGB(255, 151, 99, 204)
// //                                       .withOpacity(0.9),
// //                                   borderRadius: BorderRadius.only(
// //                                     topLeft: Radius.circular(25.0),
// //                                     topRight: Radius.circular(25.0),
// //                                     bottomLeft: Radius.circular(25.0),
// //                                     bottomRight: Radius.circular(25.0),
// //                                   ),
// //                                 ),
// //                                 child: Row(
// //                                   children: [
// //                                     Icon(Icons.person,
// //                                         color: Colors.grey[300], size: 14),
// //                                     SizedBox(
// //                                       width: 5,
// //                                     ),
// //                                     Text(
// //                                       '151k',
// //                                       style: GoogleFonts.quicksand(
// //                                         color: Colors.white,
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Padding(
// //                           padding: const EdgeInsets.only(left: 15.0, top: 10),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 Icons.play_circle_outline,
// //                                 color: Colors.white,
// //                               ),
// //                               SizedBox(
// //                                 width: 5,
// //                               ),
// //                               Text('Watch Now',
// //                                   style: GoogleFonts.averageSans(
// //                                     color: Colors.white,
// //                                     fontSize: 14,
// //                                     letterSpacing: 1,
// //                                   )),
// //                             ],
// //                           )),
// //                     ],
// //                   ),
// //                   Column(
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.only(left: 20.0),
// //                         child: Stack(
// //                           children: [
// //                             Container(
// //                               height: 145,
// //                               width: 145,
// //                               decoration: BoxDecoration(
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Color.fromARGB(115, 19, 19, 19),
// //                                     offset: const Offset(
// //                                       5.0,
// //                                       0.0,
// //                                     ),
// //                                     blurRadius: 10.0,
// //                                     spreadRadius: 2.0,
// //                                   ),
// //                                 ],
// //                                 borderRadius: BorderRadius.only(
// //                                   topLeft: Radius.circular(5.0),
// //                                   topRight: Radius.circular(5.0),
// //                                   bottomLeft: Radius.circular(5.0),
// //                                   bottomRight: Radius.circular(5.0),
// //                                 ),
// //                                 image: DecorationImage(
// //                                   image: AssetImage('images/pothole.png'),
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),

// //                              child: InkWell(onTap: ,) /* add child content here */
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Container(
// //                                 padding: EdgeInsets.only(
// //                                     top: 8, bottom: 8, left: 12, right: 12),
// //                                 decoration: BoxDecoration(
// //                                   color: Color.fromARGB(255, 151, 99, 204)
// //                                       .withOpacity(0.9),
// //                                   borderRadius: BorderRadius.only(
// //                                     topLeft: Radius.circular(25.0),
// //                                     topRight: Radius.circular(25.0),
// //                                     bottomLeft: Radius.circular(25.0),
// //                                     bottomRight: Radius.circular(25.0),
// //                                   ),
// //                                 ),
// //                                 child: Row(
// //                                   children: [
// //                                     Icon(Icons.edit_road,
// //                                         color: Colors.grey[300], size: 14),
// //                                     SizedBox(
// //                                       width: 5,
// //                                     ),
// //                                     Text(
// //                                       'nid de poule',
// //                                       style: GoogleFonts.quicksand(
// //                                         color: Colors.white,
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Padding(
// //                           padding: const EdgeInsets.only(left: 15.0, top: 10),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 Icons.play_circle_outline,
// //                                 color: Colors.white,
// //                               ),
// //                               SizedBox(
// //                                 width: 5,
// //                               ),
// //                               Text('Watch Now',
// //                                   style: GoogleFonts.averageSans(
// //                                     color: Colors.white,
// //                                     fontSize: 14,
// //                                     letterSpacing: 1,
// //                                   )),
// //                             ],
// //                           )),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),