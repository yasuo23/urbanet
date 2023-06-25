import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:urbanet/itemliste.dart/conncet.dart';

import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:urbanet/screen/profile.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:connectivity/connectivity.dart';

class idea extends StatefulWidget {
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<idea> {
  String _connectionStatus = '';
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

  void initState() {
    checkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none)
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

  final _bioController = TextEditingController();
  File? _imageFile;
  File? getimage() {
    return _imageFile;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

//----------------------------------------------
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

  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp,
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        title: Text('signalez une anomalie '),
      ),
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
      backgroundColor: Colors.white,
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
              Container(
                child: Image.asset(
                  "images/brainstorm.png",
                  width: 300,
                  height: 170,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "                 faites vos suggestions ",
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway'),
              ),
              // Text(
              //   "    Vos idées, notre avenir !",
              //   style: TextStyle(
              //       fontSize: 22.0,
              //       fontWeight: FontWeight.w600,
              //       fontFamily: 'Raleway'),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextFormField(
                  obscureText: false,
                  controller: _bioController,
                  style: const TextStyle(fontSize: 18),
                  minLines: 5,
                  maxLength: 250,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "la suggestion est obligatoire";
                    if (value.length > 250)
                      return "la suggestion ne doit pas dépasser 250  caractères";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enterez votre suggestion',
                    hintText: 'Enterez votre suggestion ',
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
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  ),
                ),
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
                                    color: Color.fromARGB(0, 63, 81, 181)),
                                child: InkWell(
                                  onTap: _pickImage,
                                  child: _imageFile == null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo[600],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(50.0),
                                                bottomRight:
                                                    Radius.circular(50.0),
                                                topLeft: Radius.circular(50.0),
                                                topRight: Radius.circular(50.0),
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
                                                borderRadius: BorderRadius.only(
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
                                                  image: FileImage(_imageFile!),
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
                                              icon: Icon(
                                                  Icons.delete_outline_sharp),
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
                            Stack(alignment: Alignment.topRight, children: [
                              Container(
                                height: 150,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50.0),
                                      bottomRight: Radius.circular(50.0),
                                      topLeft: Radius.circular(50.0),
                                      topRight: Radius.circular(50.0),
                                    ),
                                    color: Color.fromARGB(0, 63, 81, 181)),
                                child: _showVideo
                                    ? Container(
                                        child: Stack(
                                        children: [
                                          Container(
                                            width: 110,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(50.0),
                                                bottomRight:
                                                    Radius.circular(50.0),
                                                topLeft: Radius.circular(50.0),
                                                topRight: Radius.circular(50.0),
                                              ),
                                            ),
                                            child: AspectRatio(
                                              aspectRatio:
                                                  _controller.value.aspectRatio,
                                              child: VideoPlayer(_controller),
                                            ),
                                          ),
                                          Positioned(
                                            top: -13.0,
                                            right: -10.0,
                                            child: IconButton(
                                              onPressed: _deleteVideo,
                                              icon: Icon(
                                                  Icons.delete_outline_sharp),
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
                                              color: Colors.indigo[600],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(50.0),
                                                bottomRight:
                                                    Radius.circular(50.0),
                                                topLeft: Radius.circular(50.0),
                                                topRight: Radius.circular(50.0),
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
              SizedBox(height: 20),
              Container(
                  width: 400,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 65, 41, 151),
                    ),
                    onPressed: () async {
                      var avatarFile = _imageFile;
                      Position position = await _getGeoLocationPosition();
                      var lat = position.latitude;
                      int s = 3;
                      var lent = position.longitude;
                      conn u = new conn();
                      if (avatarFile != null) {
                        final result = await Supabase.instance.client
                            .from('proposition')
                            .insert({
                              'iduser': u.userId,
                              'lat': lat,
                              'lon': lent,
                              'contenu': _bioController.text
                            })
                            .select()
                            .execute();

                        final data = result.data;
                        print(data);

                        for (var row in data as List<dynamic>) {
                          s = row['id'] as int;
                        }
                        print(s);
                      }
                      print("ok");
                      final path = await Supabase.instance.client.storage
                          .from('proposition')
                          .upload(
                            'public/${u.userName}/${s}.png',
                            _imageFile!,
                            fileOptions: const FileOptions(
                                cacheControl: '3600', upsert: false),
                          );
                      final url = await Supabase.instance.client.storage
                          .from('proposition')
                          .getPublicUrl('public/${u.userName}/${s}.png');
                      print(url);
                      print(u.userId);

                      final m = await Supabase.instance.client
                          .from('proposition')
                          .update({
                            'image': url,
                          })
                          .eq('id', s)
                          .execute();
                    },
                    child: Text('envoyée'),
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
