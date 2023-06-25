import 'package:flutter/material.dart';

class typeA extends StatelessWidget {
  String title = '';
  String image = '';
  String typeS = '';
  typeA({
    required this.image,
    required this.title,
    required this.typeS,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.elliptical(20.0, 20.0)),
          splashColor: Colors.white,
          onTap: () {},
          child: SizedBox(
            width: 220,
            height: 270,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  )),
                  alignment: const Alignment(-0.10, -2.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(115, 19, 19, 19),
                          color: Color.fromARGB(202, 88, 86, 233),
                          // Color.fromARGB(255, 48, 27, 142),
                          offset: const Offset(
                            5.0,
                            0.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100.0),
                        topRight: Radius.circular(100.0),
                        bottomLeft: Radius.circular(100.0),
                        bottomRight: Radius.circular(100.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    /* add child content here */
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 35.0, bottom: 31.0, left: 50),
                    child: Text(
                      "${typeS}",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 96.0, bottom: 31.0),
                    child: Center(
                      child: Text(
                        '',
                        style:
                            TextStyle(color: Color(0xff868686), fontSize: 16.0),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                        EdgeInsets.only(top: 157.0, bottom: 31.0, left: 50),
                    child: Center(
                      child: Text(
                        "${title}",
                        style:
                            // TextStyle(color: Color(0xff5956E9), fontSize: 17.0),
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 7, 93, 252),
                                fontSize: 16.0),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
