import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:urbanet/wigetpages.dart/typesignalement.dart';
import 'dart:io';
import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:urbanet/screen/profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:supabase/supabase.dart';
import 'package:search_page/search_page.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:connectivity/connectivity.dart';

class Location {
  String address;
  double latitude;
  double longitude;
  String type;
  Color markerColor;
  String id;

  Location(
      {required this.latitude,
      required this.longitude,
      required this.type,
      required this.id,
      required this.address,
      required this.markerColor});
  List<Location> lo(List<dynamic> liste) {
    late List<Location> loc = [];

    for (var valeurs in liste) {
      loc.add(Location(
          latitude: valeurs[0],
          longitude: valeurs[1],
          markerColor: Colors.red,
          type: valeurs[2],
          address: '',
          id: valeurs[3]));
    }
    return loc;
  }
}

class map extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<map> {
  late String _connectionStatus = '';
  @override
  Set<Marker> _markers = Set();
  void initState() {
    var not = Supabase.instance.client.channel('custom-update-channel').on(
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
        debugPrint('Notification  $now');

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
    super.initState();
    checkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_connectionStatus),
        ),
      );
    });
    _en();
    var signalement =
        Supabase.instance.client.channel('custom-insert-channel').on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
              event: 'insert',
              schema: 'public',
              table: 'signalement',
            ), (payload, [ref]) async {
      print('new thing');
      print(payload);
      Map<String, dynamic> newRow = payload['new'];
      var la;
      //  = newRow['lat'];
      var lo;
      // = newRow['lon'];

      final p = await Supabase.instance.client
          .rpc('get_l', params: {'location': newRow['location']});

      for (var ro in p as List<dynamic>) {
        la = ro['lat'];
        lo = ro['lon'];
        print(lo);
        print(la);
      }
      // Access the values of the new row using the keys in the newRow map
      List<Placemark> placemarks = await placemarkFromCoordinates(la, lo);
      Placemark placemark = placemarks[0];
      var address =
          "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      var id = '${newRow['ids']}';
      _markers.add(
        Marker(
            markerId: MarkerId(id),
            position: LatLng(la, lo),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: newRow['type'], snippet: address)),
      );
      print(newRow['etat']);
      print(newRow['type']);
      // Do something fun or interesting when there is an change on the database
    }).subscribe();

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
        String d = '${newRow['ids']}';
        _markers.removeWhere((marker) => marker.markerId == d);
        print(d);
        print(newRow['etat']);
        print(newRow['type']);
      }
      print(payload);

      // Do something fun or interesting when there is an change on the database
    }).subscribe();
    _createMarkers();
  }

  Future<void> checkConnection() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = 'Connecté';
      });
    } else {
      setState(() {
        _connectionStatus = ' Pas de connexion';
      });
    }
  }

  List<Etat> selectedetatList = [];
  List<typeAa> selectedUserList = [];
  String r = "";
  List<String> s = [
    'route bloquée par la neige',
    'nid de poule',
    'fuite d\'eau',
    'route déformé',
    'égout bouchée',
    'ordure abondonnée',
    'animale mort',
    'débris de verre',
    'mobilier endomagé',
    'graffitis sur les murs',
    'chien errant',
    'instalation électrique dangereuse',
    'arbre sur le point de tombé',
  ];
  List<String> e = [
    'en cour',
    'non traitée',
    'traitée',
  ];
  List<endrois>? selectedendroie = [];

  List<endrois> listeendrois = [];
  List<String> v = [];
  List<String> c = [];
  List<typeAa>? select = [];
  Future<void> _en() async {
    conn u = conn();
    final response = await Supabase.instance.client
        .from('signalement')
        .select('commune,Quartiers')
        .execute();

    final data = response.data;
    print(data);

    List<endrois> o = [];

    if (response.status == 200) {
      for (var row in data as List<dynamic>) {
        v.add(row['Quartiers']);
        c.add(row['commune']);
        o.add(endrois(commune: row['commune'], quartier: row['Quartiers']));
      }

      o = o.toSet().toList();
      print(o);
      v = v.toSet().toList();
      c = c.toSet().toList();
      print(v);
      print(c);
    }
    print(v);
    print(c);
    print(o);
    setState(() {
      c = c;
      v = v;
      listeendrois = o;
    });
  }

  var listeValeurs = <List<String?>>[];
  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<typeAa>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Veuillez sélectionner le type ',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.typeS,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.typeS.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedUserList.clear();
          selectedUserList = List.from(list!);
        });

        _markers.clear();
        s.clear();
        print(s);
        print(selectedUserList!.length);
        for (var i in selectedUserList as List<typeAa>) {
          s.add(i.typeS);
          print("${i.typeS}");
        }

        s = s.toSet().toList();

        print(e);

        listeValeurs.clear();
        conn u = conn();
        final response = await Supabase.instance.client
            .from('signalement')
            .select('ids,type,etat,lat,lon')
            .in_('type', s)
            .in_('etat', e)
            .in_('Quartiers', v)
            .in_('commune', c)
            .execute();
        final data = response.data;
        print(data);
        int q;
        var o = <int>[];

        if (response.status == 200) {
          for (var row in data as List<dynamic>) {
            List<Placemark> placemarks =
                await placemarkFromCoordinates(row['lat'], row['lon']);
            Placemark placemark = placemarks[0];
            var address =
                "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
            q = row['ids'] as int;
            o.add(q);
            _markers.add(
              Marker(
                  markerId: MarkerId('${row['ids']}'),
                  position: LatLng(row['lat'], row['lon']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(title: row['type'], snippet: address)),
            );
          }
          setState(() {
            _markers = _markers;
          });
        }

        Navigator.pop(context);
      },
    );
  }

  Future<void> _openFilterDialog3() async {
    await FilterListDialog.display<endrois>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Veuillez sélectionner l\'endroit',
      height: 500,
      listData: listeendrois,
      selectedListData: selectedendroie,
      choiceChipLabel: (item) => item!.commune + " , " + item.quartier,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.commune.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedendroie!.clear();
          selectedendroie = List.from(list!);
        });
        {
          _markers.clear();
          v.clear();
          c.clear();
          print(selectedendroie!.length);
          for (var i in selectedendroie as List<endrois>) {
            v.add(i.quartier);
            c.add(i.commune);
          }

          v = v.toSet().toList();
          c = c.toSet().toList();
          print(r);
          print(e);
          print(s);

          listeValeurs.clear();
          conn u = conn();
          final response = await Supabase.instance.client
              .from('signalement')
              .select('ids,type,etat,commune,Quartiers,lat,lon')
              // .in_('type', s)
              .in_('type', s)
              .in_('etat', e)
              .in_('Quartiers', v)
              .in_('commune', c)
              .execute();
          final data = response.data;
          print(data);
          int q;
          var o = <int>[];

          if (response.status == 200) {
            for (var row in data as List<dynamic>) {
              List<Placemark> placemarks =
                  await placemarkFromCoordinates(row['lat'], row['lon']);
              Placemark placemark = placemarks[0];
              var address =
                  "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
              q = row['ids'] as int;
              o.add(q);
              _markers.add(
                Marker(
                    markerId: MarkerId('${row['ids']}'),
                    position: LatLng(row['lat'], row['lon']),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    infoWindow:
                        InfoWindow(title: row['type'], snippet: address)),
              );
            }
            setState(() {
              _markers = _markers;
            });
          }
        }

        Navigator.pop(context);
      },
    );
  }

  Future<void> _openFilterDialog2() async {
    await FilterListDialog.display<Etat>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Veuillez sélectionner l\'état',
      height: 500,
      listData: etatList,
      selectedListData: selectedetatList,
      choiceChipLabel: (item) => item!.etat,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.etat.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedetatList.clear();
          selectedetatList = List.from(list!);
        });
        _markers.clear();
        e.clear();
        print(e);
        print(selectedetatList!.length);
        for (var i in selectedetatList as List<Etat>) {
          e.add(i.etat);
          print("${i.etat}");
        }

        e = e.toSet().toList();

        print(e);

        listeValeurs.clear();
        conn u = conn();
        final response = await Supabase.instance.client
            .from('signalement')
            .select('ids,type,etat,lat,lon')
            .in_('type', s)
            .in_('etat', e)
            .in_('Quartiers', v)
            .in_('commune', c)
            .execute();
        final data = response.data;
        print(data);
        int q;
        var o = <int>[];

        if (response.status == 200) {
          for (var row in data as List<dynamic>) {
            List<Placemark> placemarks =
                await placemarkFromCoordinates(row['lat'], row['lon']);
            Placemark placemark = placemarks[0];
            var address =
                "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
            q = row['ids'] as int;
            o.add(q);
            _markers.add(
              Marker(
                  markerId: MarkerId('${row['ids']}'),
                  position: LatLng(row['lat'], row['lon']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(title: row['type'], snippet: address)),
            );
          }
          setState(() {
            _markers = _markers;
          });
        }

        Navigator.pop(context);
      },
    );
  }

  // List<Location> locations; List<typeAa> selectedUserList = [];

  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp
  ];
  @override
  Future<void> _createMarkers() async {
    // final result = await Supabase.instance.client
    //     .from('signalement')s
    //     .select('type ,ids,point_to_latlng(location) as l')
    //     .eq('etat', 'non traitée')
    //     .execute();
    final result = await Supabase.instance.client.rpc('get_sig', params: {});
    if (result != null) {
      final listeValeurs = <List<dynamic>>[];

      for (var row in result as List<dynamic>) {
        final lat = row['lat'];
        final lon = row['lon'];

        final type = row['type'] as String;

        final id = row['ids'] as int;
        print(lat);
        print(lon);
        print(id);

        listeValeurs.add([lat, lon, type, id]);
      }

      List<Location> locations = [];
      for (var valeurs in listeValeurs) {
        locations.add(Location(
            latitude: valeurs[0],
            longitude: valeurs[1],
            markerColor: Colors.red,
            type: valeurs[2],
            address: '',
            id: '${valeurs[3]}'));
      }
      for (var location in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        Placemark placemark = placemarks[0];
        location.address =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        _markers.add(
          Marker(
              markerId: MarkerId(location.id),
              position: LatLng(location.latitude, location.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow:
                  InfoWindow(title: location.type, snippet: location.address)),
        );
      }
      setState(() {});
    } else {
      print('errer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('la carte des signalements '),
          backgroundColor: Colors.deepPurple[900],
        ),
        backgroundColor: Color.fromRGBO(224, 215, 255, 1),
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
        body: Stack(children: [
          Container(
            alignment: Alignment.center,
            height: 630,
            width: 450,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 8,
              ),
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(36.752887, 3.042048),
                zoom: 4,
              ),
              markers: _markers,
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text('   Filtrez les signalements par type',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),
          ),
          Positioned(
            top: 16,
            right: 10,
            child: Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog2();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text('  Filtrez les signalements par état',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),
          ),
          Positioned(
            top: 100,
            right: 10,
            child: Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog3();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text('  Filtrez les signalements par endroits',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),
          )
        ]));
  }
}

class typeAa {
  final String image;
  final String title;
  final String typeS;

  typeAa({required this.image, required this.title, required this.typeS});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<typeAa> userList = [
  typeAa(
    image: 'images/icy.png',
    title: 'route',
    typeS: 'route bloquée par la neige',
  ),
  typeAa(
    image: 'images/pothole.png',
    title: 'route',
    typeS: 'nid de poule',
  ),
  typeAa(
    image: 'images/flood.png',
    title: 'fuite d\'eau  ',
    typeS: 'fuite d\'eau',
  ),
  typeAa(
    image: 'images/street.png',
    title: 'route déformé ',
    typeS: 'route déformé',
  ),
  typeAa(
    image: 'images/urban.png',
    title: 'égout bouchée',
    typeS: 'égout bouchée',
  ),
  typeAa(
    image: 'images/rubbish.png',
    title: 'ordure abondonnée  ',
    typeS: 'ordure abondonnée',
  ),
  typeAa(
    image: 'images/dead.png',
    title: 'animale mort   ',
    typeS: 'animale mort',
  ),
  typeAa(
    image: 'images/broken-bottle.png',
    title: 'débris de verre',
    typeS: 'débris de verre',
  ),
  typeAa(
    image: 'images/bench.png',
    title: 'mobilier endomagé',
    typeS: 'mobilier endomagé',
  ),
  typeAa(
    image: 'images/wall.png',
    title: 'chien errant',
    typeS: 'graffitis sur les murs',
  ),
  typeAa(
    image: 'images/dog.png',
    title: 'chien errant',
    typeS: 'chien errant',
  ),
  typeAa(
    image: 'images/electrical-panel.png',
    title: 'instalation électrique dangereuse',
    typeS: 'instalation électrique dangereuse',
  ),
  typeAa(
    image: 'images/fallen.png',
    title: 'chien errant',
    typeS: 'arbre sur le point de tombé',
  ),
];

class Etat {
  final String etat;

  Etat({required this.etat});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<Etat> etatList = [
  Etat(
    etat: 'en cour',
  ),
  Etat(
    etat: 'non traitée',
  ),
  Etat(
    etat: 'traitée',
  ),
];

class endrois {
  final String commune;
  final String quartier;

  endrois({required this.commune, required this.quartier});
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is endrois &&
          runtimeType == other.runtimeType &&
          commune == other.commune &&
          quartier == other.quartier;

  @override
  int get hashCode => commune.hashCode ^ quartier.hashCode;
}
