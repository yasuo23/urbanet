import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class typeA extends StatelessWidget {
  @override
  typeA({
    required this.image,
    required this.title,
    required this.typeS,
  });

  final String title;
  final String image;
  final String typeS;

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Stack(
            children: [
              Container(
                height: 145,
                width: 145,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // color: Color.fromARGB(115, 19, 19, 19),
                      color: Color.fromARGB(255, 48, 27, 142),
                      offset: const Offset(
                        5.0,
                        0.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                /* add child content here */
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 99, 204).withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
