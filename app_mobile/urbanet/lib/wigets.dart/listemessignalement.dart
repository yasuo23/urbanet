// import 'package:flutter/material.dart';
// import 'package:urbanet/wigetpages.dart/signaler.dart';
// import 'package:intl/intl.dart';

// class type extends StatelessWidget {
//   @override
//   type(
//       {required this.image,
//       required this.typeS,
//       required this.title,
//       required this.Etat,
//       required this.date,
//       required this.typeg,
//       // required this.func,
//       required this.col});

//   final String title;
//   final String image;
//   final String typeS;
//   final String Etat;
//   final String typeg;
//   final DateTime date;

//   // Function() func;
//   final Color col;

//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: Colors.transparent,
//         ),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => sigl(
//                         title: title,
//                         typeS: typeS,
//                         image: image,
//                       )));
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: col,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(100.0),
//               bottomRight: Radius.circular(100.0),
//               topLeft: Radius.circular(100.0),
//               topRight: Radius.circular(100.0),
//             ),
//           ),
//           height: 50,
//           width: 400,
//           child: Row(
//             children: [
//             InkWell(child : Image.asset(
//                 image,
//                 width: 50,
//                 height: 50,)
//                 onTap: (){},
              
//               ),
//               Text(
//                 typeg,
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 239, 241, 243),
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.normal,
//                   fontFamily: 'Roboto',
//                 ),
//               ),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 239, 241, 243),
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.normal,
//                   fontFamily: 'Roboto',
//                 ),
//               ),
//               Text(typeS,
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 239, 241, 243),
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.normal,
//                     fontFamily: 'Roboto',
//                   )),
//               Text(
//                 Etat,
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 239, 241, 243),
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.normal,
//                   fontFamily: 'Roboto',
//                 ),
//               ),
//               Text(
//                 DateFormat('yyyy-MM-dd').format(date),
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 239, 241, 243),
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.normal,
//                   fontFamily: 'Roboto',
//                 ),
//               ),
//             ],
//           ),
//         ));

//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
