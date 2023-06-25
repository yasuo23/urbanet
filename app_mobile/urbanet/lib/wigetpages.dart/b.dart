import 'package:flutter/material.dart';
// import 'package:urbanet/screen/authentification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:urbanet/wigetpages.dart/idea.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
// import 'package:urbanet/wigetpages.dart/archive.dart';

import 'package:carousel_slider/carousel_slider.dart';

// import 'package:urbanet/packag.dart/map2.dart';
class Screen extends StatefulWidget {
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<Screen> {
//----------------------------------------------

  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 153, 13, 13),
        body: Stack(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "images/image1.png",
                ),
                fit: BoxFit.cover,
              )),
            ),
            Positioned(
              top: 210,
              right: 106,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(100.0),
                    bottomLeft: Radius.circular(100.0),
                    bottomRight: Radius.circular(100.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage("images/nn.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                /* add child content here */
              ),
            ),
          ],
        ));
  }
}
