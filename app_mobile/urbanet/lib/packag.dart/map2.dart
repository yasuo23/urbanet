// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:urbanet/wigetpages.dart/typesignalement.dart';
// import 'dart:io';
// import 'dart:core';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase/supabase.dart';
// import 'package:search_page/search_page.dart';

// class Location {
//   String address;
//   double latitude;
//   double longitude;
//   String type;
//   Color markerColor;
//   String id;

//   Location(
//       {required this.latitude,
//       required this.longitude,
//       required this.type,
//       required this.id,
//       required this.address,
//       required this.markerColor});
//   List<Location> lo(List<dynamic> liste) {
//     late List<Location> loc = [];

//     for (var valeurs in liste) {
//       loc.add(Location(
//           latitude: valeurs[0],
//           longitude: valeurs[1],
//           markerColor: Colors.red,
//           type: valeurs[2],
//           address: '',
//           id: valeurs[3]));
//     }
//     return loc;
//   }
// }

// class map2 extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<map2> {
//   @override
//   Set<Marker> _markers = Set();
//   List<endrois>? selectedendroie = [];

//   List<endrois> listeendrois = [];
//   List<String> v = [];
//   List<String> c = [];
//   void initState() {
//     super.initState();

//     var signalement =
//         Supabase.instance.client.channel('custom-insert-channel').on(
//             RealtimeListenTypes.postgresChanges,
//             ChannelFilter(
//               event: 'insert',
//               schema: 'public',
//               table: 'signalement',
//             ), (payload, [ref]) async {
//       print('new thing');
//       print(payload);
//       Map<String, dynamic> newRow = payload['new'];
//       var la;
//       //  = newRow['lat'];
//       var lo;
//       // = newRow['lon'];

//       final p = await Supabase.instance.client
//           .rpc('get_l', params: {'location': newRow['location']});

//       for (var ro in p as List<dynamic>) {
//         la = ro['lat'];
//         lo = ro['lon'];
//         print(lo);
//         print(la);
//       }
//       // Access the values of the new row using the keys in the newRow map
//       List<Placemark> placemarks = await placemarkFromCoordinates(la, lo);
//       Placemark placemark = placemarks[0];
//       var address =
//           "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
//       var id = '${newRow['ids']}';
//       _markers.add(
//         Marker(
//             markerId: MarkerId(id),
//             position: LatLng(la, lo),
//             icon:
//                 BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//             infoWindow: InfoWindow(title: newRow['type'], snippet: address)),
//       );
//       print(newRow['etat']);
//       print(newRow['type']);
//       // Do something fun or interesting when there is an change on the database
//     }).subscribe();

//     var sig = Supabase.instance.client.channel('custom-update-channel').on(
//         RealtimeListenTypes.postgresChanges,
//         ChannelFilter(
//           event: 'update',
//           schema: 'public',
//           table: 'signalement',
//         ), (payload, [ref]) async {
//       print('update');

//       Map<String, dynamic> newRow = payload['new'];

//       // Access the values of the new row using the keys in the newRow map
//       if (newRow['etat'] as String == 'traitée') {
//         String d = '${newRow['ids']}';
//         _markers.removeWhere((marker) => marker.markerId == d);
//         print(d);
//         print(newRow['etat']);
//         print(newRow['type']);
//       }
//       print(payload);

//       // Do something fun or interesting when there is an change on the database
//     }).subscribe();
//     _createMarkers();
//   }

//   // List<Location> locations;

//   Future<void> _createMarkers() async {
//     // final result = await Supabase.instance.client
//     //     .from('signalement')s
//     //     .select('type ,ids,point_to_latlng(location) as l')
//     //     .eq('etat', 'non traitée')
//     //     .execute();
//     final result = await Supabase.instance.client.rpc('get_sig', params: {});
//     if (result != null) {
//       final listeValeurs = <List<dynamic>>[];

//       for (var row in result as List<dynamic>) {
//         final lat = row['lat'];
//         final lon = row['lon'];

//         final type = row['type'] as String;

//         final id = row['ids'] as int;
//         print(lat);
//         print(lon);
//         print(id);

//         listeValeurs.add([lat, lon, type, id]);
//       }

//       List<Location> locations = [];
//       for (var valeurs in listeValeurs) {
//         locations.add(Location(
//             latitude: valeurs[0],
//             longitude: valeurs[1],
//             markerColor: Colors.red,
//             type: valeurs[2],
//             address: '',
//             id: '${valeurs[3]}'));
//       }
//       for (var location in locations) {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//             location.latitude, location.longitude);
//         Placemark placemark = placemarks[0];
//         location.address =
//             "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
//         _markers.add(
//           Marker(
//               markerId: MarkerId(location.id),
//               position: LatLng(location.latitude, location.longitude),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueRed),
//               infoWindow:
//                   InfoWindow(title: location.type, snippet: location.address)),
//         );
//       }
//       setState(() {});
//     } else {
//       print('errer');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('la carte des signalement '),
//           backgroundColor: Colors.deepPurple[900],
//         ),
//         backgroundColor: Colors.black87,
//         body: GestureDetector(
//             onHorizontalDragEnd: (DragEndDetails details) {
//               if (details.primaryVelocity == 0) return;
//               // if (details.primaryVelocity?.compareTo(0) == -1) {
//               //   Navigator.push(
//               //       context, MaterialPageRoute(builder: (context) => type()));
//               // } else {
//               //   Navigator.of(context).pop();
//               // }
//             },
//             child: Column(children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Row(children: [
//                 SizedBox(
//                     // width: 20,
//                     ),
//                 Container(
//                   alignment: Alignment.center,
//                   height: 580,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.white,
//                       width: 8,
//                     ),
//                   ),
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(36.752887, 3.042048),
//                       zoom: 4,
//                     ),
//                     markers: _markers,
//                   ),
//                 )
//               ])
//             ])));
//   }
// }
