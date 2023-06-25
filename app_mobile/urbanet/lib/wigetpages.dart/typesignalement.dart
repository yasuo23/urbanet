// import 'package:flutter/material.dart';
// import 'package:urbanet/wigetpages.dart/signaler.dart';
// import 'package:urbanet/wigets.dart/listd.dart';
// import 'package:urbanet/packag.dart/photo.dart';
// import 'package:urbanet/itemliste.dart/liste.dart';
// import 'package:urbanet/wigets.dart/LIST.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// // import 'dart:core';

// class type extends StatelessWidget {
//   @override
//   @override
//   String location = 'Null, Press Button';
//   String address = 'search';
//   double lat = 0;
//   double lent = 0;
//   Future<Position> _getGeoLocationPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   Future<void> getAddressFromLatLong(Position position) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     print(placemarks);
//     Placemark place = placemarks[0];
//     address =
//         '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//   }

//   Widget build(BuildContext context) {
//     listS i = listS();
//     List<Map<String, dynamic>> items = i.getList();
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('type de signalemnt '),
//           backgroundColor: Colors.deepPurple[900],
//         ),
//         backgroundColor: Color.fromARGB(255, 34, 6, 113),
//         body: Center(
//             child: Column(children: [
//           SizedBox(
//             height: 40,
//           ),
//           Row(children: [
//             Text(
//               'probleme de route ',
//               style: TextStyle(
//                 color: Color.fromARGB(255, 239, 241, 243),
//                 fontSize: 35.0,
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.normal,
//                 fontFamily: 'Roboto',
//               ),
//             ),
//             Image.asset(
//               'images/motorway.png',
//               height: 50,
//               width: 50,
//             ),
//           ]),
//           // HorizontalScrollableList(data: items),
//           SizedBox(
//             height: 40,
//           ),
//           Container(
//               height: 150,
//               child: ListView(scrollDirection: Axis.horizontal, children: [
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/icy.png',
//                                     title: 'route bloquée par la neige',
//                                     typeS: 'route bloquée par la neige',
//                                     adress: '$address',
//                                       sublocality :'$sublocality',
//   locality:'$locality';,
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/icy.png',
//                       title: 'route bloquée par la neige',
//                       typeS: 'route bloquée par la neige',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/pothole.png',
//                                     title: 'nid de poule',
//                                     typeS: 'nid de poule ',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/pothole.png',
//                       title: 'nid de poule',
//                       typeS: 'nid de poule ',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/flood.png',
//                                     title: 'fuite d eau  ',
//                                     typeS: 'fuite d eau',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/flood.png',
//                       title: 'fuite d eau  ',
//                       typeS: 'fuite d eau',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/street.png',
//                                     title: 'route déformé ',
//                                     typeS: 'route déformé ',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/street.png',
//                       title: 'route déformé ',
//                       typeS: 'route déformé ',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/urban.png',
//                                     title: 'égout bouchée',
//                                     typeS: 'égout bouchée',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/urban.png',
//                       title: 'égout bouchée',
//                       typeS: 'égout bouchée ',
//                     )),
//               ])),
//           Text(
//             'propreté                 ',
//             style: TextStyle(
//               color: Color.fromARGB(255, 239, 241, 243),
//               fontSize: 35.0,
//               fontWeight: FontWeight.bold,
//               fontStyle: FontStyle.normal,
//               fontFamily: 'Roboto',
//             ),
//           ),
//           Container(
//               height: 170,
//               child: ListView(scrollDirection: Axis.horizontal, children: [
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/rubbish.png',
//                                     title: 'ordure abondonnée  ',
//                                     typeS: 'ordure abondonnée  ',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/rubbish.png',
//                       title: 'ordure abondonnée  ',
//                       typeS: 'ordure abondonnée  ',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/dead.png',
//                                     title: 'animale mort   ',
//                                     typeS: 'animale mort ',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/dead.png',
//                       title: 'animale mort   ',
//                       typeS: 'animale mort ',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/brocken-bottle.png',
//                                     title: 'débris de verre',
//                                     typeS: 'débris de verre',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/brocken-bottle.png',
//                       title: 'débris de verre',
//                       typeS: 'débris de verre',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/bench.png',
//                                     title: 'mobilier endomagé',
//                                     typeS: 'mobilier endomagé',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/bench.png',
//                       title: 'mobilier endomagé',
//                       typeS: 'mobilier endomagé',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/wall.png',
//                                     title: 'graffitis sur les murs',
//                                     typeS: 'graffitis sur les murs ',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/wall.png',
//                       title: 'graffitis sur les murs',
//                       typeS: 'graffitis sur les murs ',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/dog.png',
//                                     title: 'chien errant',
//                                     typeS: 'chien errant',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/dog.png',
//                       title: 'chien errant',
//                       typeS: 'chien errant',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/electrical-panel.png',
//                                     title: 'instalation électrique dangereuse',
//                                     typeS: 'instalation électrique dangereuse',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/electrical-panel.png',
//                       title: 'instalation électrique dangereuse',
//                       typeS: 'instalation électrique dangereuse',
//                     )),
//                 InkWell(
//                     onTap: () async {
//                       Position position = await _getGeoLocationPosition();
//                       location =
//                           'Lat: ${position.latitude} , Long: ${position.longitude}';
//                       getAddressFromLatLong(position);

//                       lat = position.latitude;
//                       lent = position.longitude;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => sigl(
//                                     image: 'images/fallen.png',
//                                     title: 'arbre sur le point de tombé',
//                                     typeS: 'arbre sur le point de tombé',
//                                     adress: '$address',
//                                     lant: lat,
//                                     long: lent,
//                                   )));
//                     },
//                     child: typeA(
//                       image: 'images/fallen.png',
//                       title: 'arbre sur le point de tombé',
//                       typeS: 'arbre sur le point de tombé',
//                     )),
//               ]))
//         ]))
//         // problème de propreté
//         ///
//         ///////
//         ///
//         ///

//         );
//   }
// }
