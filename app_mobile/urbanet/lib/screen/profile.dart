import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'dart:io';
import 'package:urbanet/wigets.dart/color.dart';
import 'package:urbanet/wigets.dart/animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:image_picker/image_picker.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:urbanet/screen/profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/Services/notifi_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum FormData { Name, Phone, Email, Gender, password, ConfirmPassword }

class profile extends StatefulWidget {
  @override
  profile();
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _connectionStatus = '';
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;

  FormData? selected;
  File? _imageFile = null;
  File? getimage() {
    return _imageFile;
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

    super.initState();
    checkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_connectionStatus),
        ),
      );
    });
  }

  Future<void> _pickImage(ImageSource s) async {
    final pickedFile = await ImagePicker().getImage(source: s);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  conn u = new conn();

  @override
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeAnimation(
                        delay: 0.8,
                        child: _imageFile == null
                            ? Container(
                                child: Row(children: [
                                Container(
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
                                      image: NetworkImage('${u.imageUser}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  /* add child content here */
                                ),
                                Container(
                                    child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.camera);
                                      },
                                      icon: Icon(Icons.camera),
                                      color: Colors.purpleAccent,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                      },
                                      icon: Icon(
                                          Icons.drive_folder_upload_outlined),
                                      color: Colors.purpleAccent,
                                    ),
                                  ],
                                ))
                              ]))
                            : Container(
                                child: Row(children: [
                                SizedBox(
                                  width: 100,
                                ),
                                Container(
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
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  /* add child content here */
                                ),
                                Container(
                                    child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.camera);
                                      },
                                      icon: Icon(Icons.camera),
                                      color: Colors.purpleAccent,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                      },
                                      icon: Icon(
                                          Icons.drive_folder_upload_outlined),
                                      color: Colors.purpleAccent,
                                    ),
                                  ],
                                ))
                              ])),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          child: Text(
                            "   votre profil.",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: selected == FormData.Email
                                ? enabled
                                : backgroundColor,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: nameController,
                            onTap: () {
                              setState(() {
                                selected = FormData.Name;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.title,
                                color: selected == FormData.Name
                                    ? enabledtxt
                                    : deaible,
                                size: 20,
                              ),
                              hintText: "${u.userName}",
                              hintStyle: TextStyle(
                                  color: selected == FormData.Name
                                      ? enabledtxt
                                      : deaible,
                                  fontSize: 12),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.Name
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: selected == FormData.Phone
                                ? enabled
                                : backgroundColor,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: phoneController,
                            onTap: () {
                              setState(() {
                                selected = FormData.Phone;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.phone_android_rounded,
                                color: selected == FormData.Phone
                                    ? enabledtxt
                                    : deaible,
                                size: 20,
                              ),
                              hintText: '${u.userphone}',
                              hintStyle: TextStyle(
                                  color: selected == FormData.Phone
                                      ? enabledtxt
                                      : deaible,
                                  fontSize: 12),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.Phone
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: selected == FormData.Email
                                ? enabled
                                : backgroundColor,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: emailController,
                            onTap: () {
                              setState(() {
                                selected = FormData.Email;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: selected == FormData.Email
                                    ? enabledtxt
                                    : deaible,
                                size: 20,
                              ),
                              hintText: '${u.userEmail}',
                              hintStyle: TextStyle(
                                  color: selected == FormData.Email
                                      ? enabledtxt
                                      : deaible,
                                  fontSize: 12),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.Email
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: selected == FormData.password
                                  ? enabled
                                  : backgroundColor),
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: passwordController,
                            onTap: () {
                              setState(() {
                                selected = FormData.password;
                              });
                            },
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_open_outlined,
                                  color: selected == FormData.password
                                      ? enabledtxt
                                      : deaible,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: ispasswordev
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: selected == FormData.password
                                              ? enabledtxt
                                              : deaible,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: selected == FormData.password
                                              ? enabledtxt
                                              : deaible,
                                          size: 20,
                                        ),
                                  onPressed: () => setState(
                                      () => ispasswordev = !ispasswordev),
                                ),
                                hintText: 'Modifiez votre mot de passe',
                                hintStyle: TextStyle(
                                    color: selected == FormData.password
                                        ? enabledtxt
                                        : deaible,
                                    fontSize: 12)),
                            obscureText: ispasswordev,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.password
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: selected == FormData.ConfirmPassword
                                  ? enabled
                                  : backgroundColor),
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: confirmPasswordController,
                            onTap: () {
                              setState(() {
                                selected = FormData.ConfirmPassword;
                              });
                            },
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_open_outlined,
                                  color: selected == FormData.ConfirmPassword
                                      ? enabledtxt
                                      : deaible,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: ispasswordev
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: selected ==
                                                  FormData.ConfirmPassword
                                              ? enabledtxt
                                              : deaible,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: selected ==
                                                  FormData.ConfirmPassword
                                              ? enabledtxt
                                              : deaible,
                                          size: 20,
                                        ),
                                  onPressed: () => setState(
                                      () => ispasswordev = !ispasswordev),
                                ),
                                hintText: 'confirmez votre mot de passe',
                                hintStyle: TextStyle(
                                    color: selected == FormData.ConfirmPassword
                                        ? enabledtxt
                                        : deaible,
                                    fontSize: 12)),
                            obscureText: ispasswordev,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.ConfirmPassword
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: TextButton(
                            onPressed: () async {
                              var iml = _imageFile;
                              if (iml != null) {
                                final path = await Supabase
                                    .instance.client.storage
                                    .from('profile')
                                    .update(
                                      'public/${u.userName}.png',
                                      iml,
                                      fileOptions: const FileOptions(
                                          cacheControl: '3600', upsert: false),
                                    );
                              }
                              if ((confirmPasswordController.text != null)) {
                                if (confirmPasswordController.text ==
                                    passwordController.text) {
                                  final UserResponse res = await Supabase
                                      .instance.client.auth
                                      .updateUser(
                                    UserAttributes(
                                      password: '${passwordController.text}',
                                    ),
                                  );
                                  final User? updatedUser = res.user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            ' le mot de passe  est modifié ')),
                                  );
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          ' Confirme mot de passe et mot de passe sont différents')),
                                );
                              }

                              var acct = Supabase.instance.client
                                  .from("Utilisateurs")
                                  .update({
                                    'nom': nameController.text,
                                    'email': emailController.text,
                                    'num_tel': phoneController.text,
                                    'photoProfila': u.imageUser
                                  })
                                  .eq('idu', u.userId)
                                  .execute();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(' le compte  est modifié ')),
                              );
                            },
                            child: Text(
                              "Modifiez votre compte",
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF2697FF),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 80),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0)))),
                      ),
                    ],
                  ),
                ),

                //End of Center Card
                //Start of outer card
                const SizedBox(
                  height: 20,
                ),

                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(" ",
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          )),
                      GestureDetector(
                        onTap: () async {
                          final response = await Supabase.instance.client
                              .from('Utilisateurs')
                              .delete()
                              .eq('email', u.userEmail)
                              .execute();

                          // User deleted successfully
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(' le compte est supprimé')),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text("Supprimez le compte",
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 6, 6)
                                    .withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
