import 'package:flutter/material.dart';
// import 'package:urbanet/screen/authentification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:urbanet/wigetpages.dart/idea.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
// import 'package:urbanet/wigetpages.dart/archive.dart';
import 'package:urbanet/wigetpages.dart/ar.dart';
import 'package:urbanet/wigetpages.dart/map.dart';

import 'package:urbanet/wigetpages.dart/mesSignalement.dart';

import 'package:urbanet/screen/carditem.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:urbanet/screen/profile.dart';
// import 'package:urbanet/packag.dart/map2.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:urbanet/screen/typeslide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "fin

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        debugPrint('Notification  $now');

        var scheduleTime = now;

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

  bool _switchValue = false;

  @override
  @override
  @override
  conn g = new conn();
  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp
  ];

  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      appBar: AppBar(
        title: Text('          Accueile'),
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "images/back.jpg",
            ),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                      Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              "images/hh.png",
                            ),
                            fit: BoxFit.fill,
                          )),
                          width: 360,
                          height: 240),
                      Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.only()),
                          height: 450,
                          child: CarouselSlider(
                              carouselController: buttonCarouselController,
                              items: [
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => type(),
                                          ));
                                    },
                                    child: typeA(
                                      image: 'images/siren (1).png',
                                      title:
                                          '  Signalez, protégez, embellissez : Ensemble, faisons de nos rues un lieu idéal ',
                                      typeS: ' Signalez une anomalie',
                                    )),
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => map(),
                                          //DeviceIdWidget(),
                                        ),
                                      );
                                    },
                                    child: typeA(
                                      image: 'images/geography.png',
                                      title:
                                          '   visualiser les signalements dans votre région ',
                                      typeS: 'Carte des signalements',
                                    )),
                                InkWell(
                                    onTap: () async {
                                      const launchUri =
                                          'https://shapeyou.fr/en';
                                      if (await canLaunch(launchUri)) {
                                        await launch(launchUri);
                                      } else {
                                        print('cant launch ');
                                      }
                                    },
                                    child: typeA(
                                      image: 'images/sos.png',
                                      title:
                                          ' en cas d\'urgence, veuillez appeler la Protection Civile immédiatement',
                                      typeS: 'Appel ugences ',
                                    )),
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DialogueFilter(),
                                          ));
                                    },
                                    child: typeA(
                                      image: 'images/folder.png',
                                      title:
                                          ' consultez vos anciens signalements. ',
                                      typeS: 'Mes signalements ',
                                    )),
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => profile(),
                                          ));
                                    },
                                    child: typeA(
                                      image: 'images/woman.png',
                                      title:
                                          'consultez votre profile                                           ',
                                      typeS: 'Profile     ',
                                    )),
                                InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => idea(),
                                          ));
                                    },
                                    child: typeA(
                                      image: 'images/idea.png',
                                      title:
                                          '  ensemble, construisons     une ville meilleure : Vos    idées, notre avenir ! ',
                                      typeS: ' Faites des suggestions',
                                    )),
                              ],
                              options: CarouselOptions(
                                height: 400,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                initialPage: 2,
                              )))
                    ],
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     SizedBox(width: 20),
              //     Container(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           IconButton(
              //             onPressed: () async {
              //               const url = 'tel:0123456789';
              //               if (await canLaunch(url)) {
              //                 await launch(url);
              //               } else {
              //                 throw 'Impossible de lancer $url';
              //               }
              //             },
              //             icon: Icon(
              //               Icons.add_ic_call_outlined,

              //               //  Icons.add_a_photo_outlined
              //               // Icons.account_circle_outlined   ,
              //               // Icons.lightbulb_outline_rounded,
              //               color: Colors.deepPurple[900],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Spacer(flex: 1),
              //     Container(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           IconButton(
              //             onPressed: () {
              //               launch('tel:1234567890');
              //             },
              //             icon: Icon(
              //               Icons.add_ic_call_outlined,
              //               color: Colors.deepPurple[900],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Spacer(flex: 1),
              //     Container(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           IconButton(
              //             onPressed: () async {
              //               final Uri launchUri = Uri(
              //                 scheme: 'tel',
              //                 path: "05403339",
              //               );
              //               if (await canLaunchUrl(launchUri)) {
              //                 await launchUrl(launchUri);
              //               } else {
              //                 print('cant launch ');
              //               }
              //             },
              //             icon: Icon(
              //               Icons.add_ic_call_outlined,
              //               color: Colors.deepPurple[900],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 30),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('           Notifications'),
      content: Row(
        children: [
          Text(
            'Recevoir des notifications',
            style: TextStyle(fontSize: 15),
          ),
          Switch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
        ],
      ),
      actions: [
        FloatingActionButton(
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
