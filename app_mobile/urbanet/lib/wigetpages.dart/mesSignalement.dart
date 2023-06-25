import 'package:flutter/material.dart';

import 'package:urbanet/wigets.dart/LIST.dart';

class sig extends StatelessWidget {
  @override
  String? dateT;
  sig(
      {required this.title,
      required this.image,
      required this.typeS,
      this.dateT,
      required this.dateS,
      required this.adress,
      required this.etat,
      required this.logo});

  final String title;
  final String image;
  final String typeS;
  final String dateS;
  final String adress;
  final String etat;
  final String logo;

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFF0C9869),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        height: 100,
        width: 350,
        child: InkWell(
          child: Row(
            children: [
              typeA(
                image: logo,
                title: typeS,
                typeS: typeS,
              ),
              Image.asset(image),
              Column(
                children: [
                  Text(
                    'etat:${etat}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 239, 241, 243),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    'address:${adress}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 239, 241, 243),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    'date du signalement :${dateS}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 239, 241, 243),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  if (dateT != null)
                    Text('date du signalement :${dateS}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 239, 241, 243),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                        )),
                ],
              ),
              InkWell(
                child: typeA(
                  image: image,
                  title: '',
                  typeS: '',
                ),
              ),
            ],
          ),
        ));

    // TODO: implement build
    throw UnimplementedError();
  }
}
