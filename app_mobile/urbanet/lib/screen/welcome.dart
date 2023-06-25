import 'package:flutter/material.dart';
// import 'package:urbanet/screen/authentification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:urbanet/wigetpages.dart/idea.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
// import 'package:urbanet/wigetpages.dart/archive.dart';
import 'package:urbanet/wigetpages.dart/ar.dart';
import 'package:urbanet/wigetpages.dart/map.dart';
import 'package:urbanet/wigetpages.dart/anonymetype.dart';

import 'package:urbanet/screen/carditem.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:urbanet/screen/profile.dart';
// import 'package:urbanet/packag.dart/map2.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:urbanet/packag.dart/photo.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Screen extends StatefulWidget {
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<Screen> {
  void initState() {
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
//----------------------------------------------

  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: const AssetImage(
                "images/welcom.png",
              ),
            ),
          ),
          child: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 500.0, bottom: 31.0),
                  child: Column(children: [
                    Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(125, 63, 171, 186),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            conn.disconnect();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Column(children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text("Connectez-vous",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 106, 81, 235),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Raleway')),
                          ])),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(125, 63, 171, 186),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            conn us = new conn();
                            us.setconn('ce351182-15dc-4ce3-9919-ef53b59f755e',
                                'anonyme', 'anonyme@gmail.com', '', '');
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => type()
                                    // type(),
                                    ));
                          },
                          child: Column(children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(" Signalez une anomalie",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 106, 81, 235),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Raleway')),
                          ])),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(125, 63, 171, 186),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                        ),
                        child: InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: "1021",
                              );
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              } else {
                                print('cant launch ');
                              }
                            },
                            child: Column(children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(" Appel d\'urgence ",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 106, 81, 235),
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Raleway')),
                            ]))),
                  ]))),
        ),
      ),
    );
  }
}
