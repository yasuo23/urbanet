import 'package:flutter/material.dart';
import 'package:urbanet/wigetpages.dart/signaler.dart';
import 'package:urbanet/wigets.dart/listd.dart';
import 'package:urbanet/packag.dart/photo.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:urbanet/itemliste.dart/liste.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:urbanet/wigets.dart/LIST.dart';
import 'package:urbanet/screen/carditem.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:urbanet/screen/profile.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';
// import 'dart:core';

class type extends StatefulWidget {
  State<type> createState() => _typeState();
}

class _typeState extends State<type> {
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Color(0xff212121),
      systemNavigationBarColor: Color(0xff212121),
      statusBarColor: Colors.amberAccent,
    ));
    super.initState();

    var sig = Supabase.instance.client.channel('custom-update-channel').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          event: 'update',
          schema: 'public',
          table: 'signalement',
        ), (payload, [ref]) async {
      print('update');

      Map<String, dynamic> newRow = payload['new'];

      // Access the values of the new row using the keys in the newRow map
      if (newRow['etat'] as String == 'traitée') {
        var now = DateTime.now();
        debugPrint('Notification de  $now');

        var scheduleTime = now.add(const Duration(seconds: 5));

        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'Notification',
            body:
                'votre signalment du type ${newRow['type']} signaler le ${newRow['DateS']} est traitée ',
            scheduledNotificationDateTime: scheduleTime);

        print(newRow['etat']);
      }
      print(payload);

      // Do something fun or interesting when there is an change on the database
    }).subscribe();
  }

  @override
  @override
  String location = 'Null, Press Button';
  String address = 'search';
  String sublocality = '';
  String locality = '';
  double lat = 0;
  double lent = 0;
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    sublocality = '${place.subLocality}';
    locality = '${place.locality}';
  }

  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp,
  ];
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    listS i = listS();
    List<Map<String, dynamic>> items = i.getList();
    return Scaffold(
        appBar: AppBar(
          title: Text('type de signalemnt '),
          backgroundColor: Colors.deepPurple[900],
        ),
        backgroundColor: Colors.deepPurple[300],
        //  Color.fromARGB(255, 34, 6, 113),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          height: 80,
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = !isActive ? Colors.white54 : Colors.white;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    index == 0
                        ? "Accueil"
                        : index == 1
                            ? "notification"
                            : index == 2
                                ? "profile"
                                : "déconnexion",
                    maxLines: 1,
                    style: TextStyle(color: color),
                  ),
                )
              ],
            );
          },
          backgroundColor: Colors.black,
          activeIndex: currentIndexBottomBar,
          splashColor: Colors.purple[500],
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.softEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) {
            setState(() => currentIndexBottomBar = index);

            switch (index) {
              case 0:
                // Remplacez HomeWidget par le widget de votre page d'accueil
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
                break;
              case 1:
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog();
                  },
                );
                // return NotificationWidget(); // Remplacez NotificationWidget par le widget de votre page de notifications
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => profile(),
                    ));
                break;
              case 3:
                conn.disconnect();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
                break; // Remplacez DisconnectWidget par le widget de votre page de déconnexion
              default:
                return Container();
            }
          },
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage(
                  "images/back.jpg",
                ),
              ),
            ),
            child: Center(
              child: ListView(scrollDirection: Axis.vertical, children: [
                const Padding(
                  padding: EdgeInsets.only(right: 40, top: 55.0, left: 50),
                  child: Text(
                    ' faite votre      signalement',
                    selectionColor: Colors.white,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 34.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  height: 500,
                  child: ContainedTabBarView(
                    tabBarProperties: const TabBarProperties(
                        unselectedLabelColor: Color(0xff9a9a9d),
                        labelColor: Color(0xff5956E9),
                        labelPadding: EdgeInsets.zero,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(left: 48, bottom: 10, top: 5),
                        indicatorColor: Color(0xff5956E9)),
                    tabs: const [
                      Text(
                        'route',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'propreté      ',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'autre    ',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                    views: [
                      Container(
                          height: 450,
                          child: CarouselSlider(
                            carouselController: buttonCarouselController,
                            items: [
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/icy.png',
                                                title: ' ',
                                                typeS:
                                                    'route bloquée par la neige',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/icy.png',
                                    title: '',
                                    typeS: 'route bloquée par la neige',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/pothole.png',
                                                title: '',
                                                typeS: 'nid de poule',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/pothole.png',
                                    title: '',
                                    typeS: 'nid de poule',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/flood.png',
                                                title: ' ',
                                                typeS: 'fuite d eau',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/flood.png',
                                    title: ' ',
                                    typeS: 'fuite d\'eau',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/street.png',
                                                title: 'route déformé',
                                                typeS: 'route déformé',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/street.png',
                                    title: '',
                                    typeS: 'route déformé',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/urban.png',
                                                title: '',
                                                typeS: 'égout bouchée',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/urban.png',
                                    title: '',
                                    typeS: 'égout bouchée',
                                  )),
                            ],
                            options: CarouselOptions(
                              height: 600,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              initialPage: 2,
                            ),
                          )),
                      Container(
                          height: 450,
                          child: CarouselSlider(
                            carouselController: buttonCarouselController,
                            items: [
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/rubbish.png',
                                                title: '',
                                                typeS: 'ordure abondonnée',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/rubbish.png',
                                    title: '',
                                    typeS: 'ordure abondonnée',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/dead.png',
                                                title: '',
                                                typeS: 'animale mort',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/dead.png',
                                    title: '',
                                    typeS: 'animale mort',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image:
                                                    'images/brocken-bottle.png',
                                                title: '',
                                                typeS: 'débris de verre',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/broken-bottle.png',
                                    title: '',
                                    typeS: 'débris de verre',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/bench.png',
                                                title: '',
                                                typeS: 'mobilier endomagé',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/bench.png',
                                    title: '',
                                    typeS: 'mobilier endomagé',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/wall.png',
                                                title: '',
                                                typeS: 'graffitis sur les murs',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/wall.png',
                                    title: '',
                                    typeS: 'graffitis sur les murs',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/dog.png',
                                                title: '',
                                                typeS: 'chien errant',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/dog.png',
                                    title: '',
                                    typeS: 'chien errant',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image:
                                                    'images/electrical-panel.png',
                                                title: '',
                                                typeS:
                                                    'instalation électrique dangereuse',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/electrical-panel.png',
                                    title: '',
                                    typeS: 'instalation électrique dangereuse',
                                  )),
                              InkWell(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    getAddressFromLatLong(position);

                                    lat = position.latitude;
                                    lent = position.longitude;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sigl(
                                                image: 'images/fallen.png',
                                                title: '',
                                                typeS:
                                                    'arbre sur le point de tombé',
                                                adress: '$address',
                                                lant: lat,
                                                long: lent,
                                                sublocality: '$sublocality',
                                                locality: '$locality')));
                                  },
                                  child: typeA(
                                    image: 'images/fallen.png',
                                    title: '',
                                    typeS: 'arbre sur le point de tombé',
                                  )),
                            ],
                            options: CarouselOptions(
                              height: 500,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              initialPage: 2,
                            ),
                          )),
                      Container(
                        height: 450,
                        child: InkWell(
                            onTap: () async {
                              Position position =
                                  await _getGeoLocationPosition();
                              location =
                                  'Lat: ${position.latitude} , Long: ${position.longitude}';
                              getAddressFromLatLong(position);

                              lat = position.latitude;
                              lent = position.longitude;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => sigl(
                                          image: 'images/siren (1).png',
                                          title: ' ',
                                          typeS: 'autre ',
                                          adress: '$address',
                                          lant: lat,
                                          long: lent,
                                          sublocality: '$sublocality',
                                          locality: '$locality')));
                            },
                            child: typeA(
                              image: 'images/siren (1).png',
                              title: ' ',
                              typeS: 'autre ',
                            )),
                      ),
                    ],
                    onChange: (index) => print(index),
                  ),
                ),
                // Container(
                //     color: Colors.purple.shade50,
                //     child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                //       SizedBox(width: 20),
                //       Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             IconButton(
                //               onPressed: () async {},
                //               icon: Icon(
                //                 Icons.home_outlined,

                //                 //  Icons.add_a_photo_outlined
                //                 // Icons.account_circle_outlined   ,
                //                 // Icons.lightbulb_outline_rounded,
                //                 color: Colors.deepPurple[900],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Spacer(flex: 1),
                //       Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             IconButton(
                //               onPressed: () {},
                //               icon: Icon(
                //                 Icons.notifications_active_outlined,
                //                 color: Colors.deepPurple[900],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Spacer(flex: 1),
                //       Container(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             IconButton(
                //               onPressed: () async {},
                //               icon: Icon(
                //                 Icons.person,
                //                 color: Colors.deepPurple[900],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       SizedBox(width: 30),
                //     ]))
              ]),
            )
            // problème de propreté
            ///
            ///////
            ///
            ///

            ));
  }
}
