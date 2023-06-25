import 'package:flutter/material.dart';
import 'dart:io';
import 'package:urbanet/wigets.dart/color.dart';
import 'package:urbanet/wigets.dart/animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:connectivity/connectivity.dart';

enum FormData { Name, Phone, Email, Gender, password, ConfirmPassword }

class Screen extends StatefulWidget {
  @override
  Screen();
  State<Screen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Screen> {
  String _connectionStatus = '';
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                SizedBox(width: 100),
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
                                      image: AssetImage("images/woman.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  /* add child content here */
                                ),
                                // AvatarImage(
                                //   backgroundImage:
                                //       AssetImage("images/woman.png"),
                                //   shape: AvatarImageShape.circle,
                                //   size: ImageSize.large,

                                // ),
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
                        height: 0,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          child: Text("Créez votre compte",
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Raleway')),
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
                              hintText: 'nom complet',
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
                              hintText: 'numéro de téléphone',
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
                              hintText: 'Email',
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
                                hintText: 'mot de passe',
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
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // FadeAnimation(
                      //   delay: 1,
                      //   child: TextButton(
                      //       onPressed: () async {
                      //         var sing = Supabase.instance.client.auth.signUp(
                      //             password: confirmPasswordController.text,
                      //             email: emailController.text);

                      //         final path = await Supabase
                      //             .instance.client.storage
                      //             .from('profile')
                      //             .upload(
                      //               'public/${nameController}.png',
                      //               _imageFile,
                      //               fileOptions: const FileOptions(
                      //                   cacheControl: '3600', upsert: false),
                      //             );
                      //         final url = await Supabase
                      //             .instance.client.storage
                      //             .from('profile')
                      //             .getPublicUrl(
                      //                 'public/${nameController}.png');

                      //         var acct = Supabase.instance.client
                      //             .from("Utilisateurs")
                      //             .insert({
                      //           'nom': nameController.text,
                      //           'email': emailController.text,
                      //           'num_tel': phoneController.text,
                      //           'photoProfila': url
                      //         }).execute();
                      //       },
                      //       child: Text(
                      //         "Sign Up",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           letterSpacing: 0.5,
                      //           fontSize: 16.0,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       style: TextButton.styleFrom(
                      //           backgroundColor: const Color(0xFF2697FF),
                      //           padding: const EdgeInsets.symmetric(
                      //               vertical: 14.0, horizontal: 80),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius:
                      //                   BorderRadius.circular(12.0)))),
                      // ),
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
                  child: TextButton(
                      onPressed: () async {
                        if (_imageFile == null)
                          _imageFile = File("images/woman.png");
                        var sing = Supabase.instance.client.auth.signUp(
                            password: confirmPasswordController.text,
                            email: emailController.text);

                        final path = await Supabase.instance.client.storage
                            .from('profile')
                            .upload(
                              'public/${nameController}.png',
                              _imageFile!,
                              fileOptions: const FileOptions(
                                  cacheControl: '3600', upsert: false),
                            );
                        final url = await Supabase.instance.client.storage
                            .from('profile')
                            .getPublicUrl('public/${nameController}.png');

                        var acct = Supabase.instance.client
                            .from("Utilisateurs")
                            .insert({
                          'nom': nameController.text,
                          'email': emailController.text,
                          'num_tel': phoneController.text,
                          'photoProfila': url
                        }).execute();
                      },
                      child: Text(
                        "Créez votre compte",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 128, 38, 255),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 80),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)))),
                ),

                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Si vous avez un compte ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 19, 19),
                            letterSpacing: 0.5,
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));
                        },
                        child: Text("connectez-vous",
                            style: TextStyle(
                                color: Color.fromARGB(255, 39, 57, 195)
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
