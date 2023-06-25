import 'package:flutter/material.dart';

import 'package:urbanet/packag.dart/map.dart';
import 'package:image/image.dart' as img;

import 'package:urbanet/screen/profile.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:urbanet/wigetpages.dart/home.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:urbanet/itemliste.dart/conncet.dart';

import 'package:video_player/video_player.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class sigl extends StatefulWidget {
  sigl(
      {required this.title,
      required this.image,
      required this.typeS,
      required this.adress,
      required this.long,
      required this.lant,
      required this.locality,
      required this.sublocality});

  final String sublocality;
  final String locality;
  final String title;
  final String image;
  final String typeS;
  final String adress;
  final double long;
  final double lant;

  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<sigl> {
  String _connectionStatus = '';
  void initState() {
    checkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_connectionStatus),
        ),
      );
    });
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

  Future<void> checkConnection() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = 'Connecté';
      });
    } else {
      setState(() {
        //  _connectionStatus = ' Pas de connexion';
      });
    }
  }

  File? _imageFile;
  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp
  ];
  final _bioController = TextEditingController();
  TextEditingController dController = new TextEditingController();
  File? getimage() {
    return _imageFile;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _checkImageResolution();
      });
    }
  }

  Future<void> _checkImageResolution() async {
    final imageBytes = await _imageFile!.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage != null) {
      final width = decodedImage.width;
      final height = decodedImage.height;
      final resolutionX = (width / _getImageInches(width)).round();
      final resolutionY = (height / _getImageInches(height)).round();

      print('Image resolution: $resolutionX DPI (X), $resolutionY DPI (Y)');
      if (resolutionX <= 200 || resolutionY <= 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('la résolution est bonne '),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Il faut refaire l\'image '),
          ),
        );
      }
    }
  }

  double _getImageInches(int pixels) {
    // Assuming 72 pixels per inch (standard DPI for screens)
    return pixels / 72.0;
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  // ---------------------------------------------
  VideoPlayerController _controller = VideoPlayerController.network('');
  bool _showVideo = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _showVideo = true;
        _controller = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            _controller.play();
            _startTimer();
          });
      });
    }
  }

  void _startTimer() {
    Future.delayed(Duration(minutes: 1), () {
      if (_showVideo) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _controller.pause();
    print('Video duration limit reached');
  }

  void _deleteVideo() {
    setState(() {
      _showVideo = false;
      _controller.pause();
      _controller = VideoPlayerController.network('');
    });
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: _deleteVideo,
        ),
      ],
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 150),
          primary: Color.fromARGB(255, 65, 41, 151),
        ),
        onPressed: _pickVideo,
        child: InkWell(
          child: Image.asset(
            'images/video-player.png',
          ),
        ));
  }

// -----------------------------------------------------
  String _text = '';
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: Text('signalez une anomalie '),
      ),
      backgroundColor: Colors.white,
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
                      ? "Home"
                      : index == 1
                          ? "notification"
                          : index == 2
                              ? "Account"
                              : "disconnect",
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
                  fit: BoxFit.cover,
                  image: const AssetImage(
                    "images/back.jpg",
                  ),
                ),
              ),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        widget.typeS,
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 6, 113),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Image.asset(
                        widget.image,
                        height: 20,
                        width: 20,
                      ),
                    ]),
                    SizedBox(
                      width: 300,
                      height: 20,
                    ),
                    Text(
                        '          adresse                                         ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 6, 113),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                            border: Border.all(
                              color: Color.fromARGB(255, 73, 131,
                                  212), // Set the border color to purple
                              width: 2.0, // Set the border width
                            )),
                        child: Column(children: [
                          Container(
                              height: 20,
                              width: 400,
                              decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //   color: Color.fromARGB(255, 34, 6,
                                  //       113), // Set the border color to purple
                                  //   width: 2.0, // Set the border width
                                  // )),
                                  ),
                              child: Text(
                                '              ${widget.adress}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 34, 6, 113),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 120,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.0),
                                  bottomRight: Radius.circular(50.0),
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0),
                                ),
                              ),
                              child: map(
                                  latitude: widget.lant,
                                  longitude: widget.long,
                                  adress: widget.typeS)),
                          SizedBox(
                            height: 10,
                          ),
                        ])),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '  description du signalement                            ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 34, 6, 113),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: TextFormField(
                        obscureText: false,
                        controller: _bioController,
                        style: const TextStyle(fontSize: 18),
                        minLines: 5,
                        maxLength: 250,
                        maxLines: 8,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (value.length > 250)
                            return "la description ne doit pas dépasser 250  caractères";
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'description du signalement   ',
                          hintText: 'description du signalement   ',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                            height: 200,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 115,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(0, 63, 81, 181)),
                                      child: InkWell(
                                        onTap: _pickImage,
                                        child: _imageFile == null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.indigo[600],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(50.0),
                                                      bottomRight:
                                                          Radius.circular(50.0),
                                                      topLeft:
                                                          Radius.circular(50.0),
                                                      topRight:
                                                          Radius.circular(50.0),
                                                    ),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                          'images/image.png',
                                                        ),
                                                        fit: BoxFit.contain)),
                                                width: 110.0,
                                                height: 150.0,
                                              )
                                            : Container(
                                                child: Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                50.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                50.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                50.0),
                                                        topRight:
                                                            Radius.circular(
                                                                50.0),
                                                      ),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                            _imageFile!),
                                                        fit: BoxFit.cover,
                                                      )),
                                                  width: 110.0,
                                                  height: 150.0,
                                                ),
                                                Positioned(
                                                  top: -13.0,
                                                  right: -10.0,
                                                  child: IconButton(
                                                    onPressed: _clearImage,
                                                    icon: Icon(Icons
                                                        .delete_outline_sharp),
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ])),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        // ),
                        SizedBox(width: 4),
                        Container(
                            height: 200,
                            width: 110,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 110,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(50.0),
                                                bottomRight:
                                                    Radius.circular(50.0),
                                                topLeft: Radius.circular(50.0),
                                                topRight: Radius.circular(50.0),
                                              ),
                                              color: Color.fromARGB(
                                                  0, 63, 81, 181)),
                                          child: _showVideo
                                              ? Container(
                                                  child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 110,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  50.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  50.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  50.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  50.0),
                                                        ),
                                                      ),
                                                      child: AspectRatio(
                                                        aspectRatio: _controller
                                                            .value.aspectRatio,
                                                        child: VideoPlayer(
                                                            _controller),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -13.0,
                                                      right: -10.0,
                                                      child: IconButton(
                                                        onPressed: _deleteVideo,
                                                        icon: Icon(Icons
                                                            .delete_outline_sharp),
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              : Container(
                                                  width: 110.0,
                                                  height: 150.0,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.indigo[600],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  50.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  50.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  50.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  50.0),
                                                        ),
                                                      ),
                                                      child: InkWell(
                                                        onTap: _pickVideo,
                                                        child: Image.asset(
                                                          'images/video-player.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ))),
                                        ),
                                      ])
                                ])),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 65, 41, 151),
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('votre signalement est envoyé '),
                              ),
                            );
                            var avatarFile = _imageFile;

                            conn u = new conn();
                            if (avatarFile != null) {
                              final data2 = await Supabase.instance.client
                                  .rpc('nearby_sig', params: {
                                'lat': widget.lant,
                                'long': widget.long,
                                't': widget.typeS
                              });
                              int vd = 23;

                              int s = 2;
                              print("ok");
                              if (data2 != null) {
                                for (var row in data2 as List<dynamic>) {
                                  s = data2[0]['ids'] as int;
                                  vd = data2[0]['dist_meters']?.toInt() ?? 0;
                                }
                                print(data2);
                              }
                              print(data2);
                              if (vd > 20) {
                                final result = await Supabase.instance.client
                                    .from('signalement')
                                    .insert({
                                      'location':
                                          'POINT(${widget.long} ${widget.lant})',
                                      'lat': widget.lant,
                                      'lon': widget.long,
                                      'type': widget.typeS,
                                      'etat': 'non traitée',
                                      'commune': widget.locality,
                                      'Quartiers': widget.sublocality
                                    })
                                    .select()
                                    .execute();

                                final data = result.data;
                                print(data);

                                for (var row in data as List<dynamic>) {
                                  s = row['ids'] as int;
                                }
                                print(s);
                              }
                              print("ok");
                              final path = await Supabase
                                  .instance.client.storage
                                  .from('signalement')
                                  .upload(
                                    'public/${u.userName}/${s}.png',
                                    avatarFile,
                                    fileOptions: const FileOptions(
                                        cacheControl: '3600', upsert: false),
                                  );
                              final url = await Supabase.instance.client.storage
                                  .from('signalement')
                                  .getPublicUrl(
                                      'public/${u.userName}/${s}.png');
                              print(url);
                              print(u.userId);

                              final m = await Supabase.instance.client
                                  .from('multimedia')
                                  .insert({
                                'img': url,
                                'ids': s,
                                'idu': u.userId,
                                'description': _bioController.text,
                              }).execute();
                            }
                          },
                          child: Text('signaler'),
                        ))
                  ],
                ),
              ))),
    );
  }
}
