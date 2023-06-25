import 'package:flutter/material.dart';
import 'package:urbanet/screen/casoullet.dart';
import 'package:urbanet/wigets.dart/color.dart';
import 'package:urbanet/wigets.dart/animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:urbanet/wigetpages.dart/create.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';
import 'package:supabase/supabase.dart';
import 'package:urbanet/screen/typeslide.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
// import 'package:urbanet/screen/createcompte.dart';
import 'package:connectivity/connectivity.dart';

enum FormData {
  Email,
  password,
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _connectionStatus = '';
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
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

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String pass = "";
  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase;
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
                Card(
                  elevation: 10,
                  color: Color.fromARGB(255, 250, 251, 251),
                  // .withOpacity(0.4),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeAnimation(
                          delay: 1,
                          child: Image.asset(
                            "images/login (1).jpg",
                            width: 300,
                            height: 170,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FadeAnimation(
                          delay: 1,
                          child: const Text("connectez-vous",
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Raleway')),
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
                                  Icons.supervised_user_circle_outlined,
                                  color: selected == FormData.Email
                                      ? enabledtxt
                                      : deaible,
                                  size: 20,
                                ),
                                hintText: 'nom d\'utilisateur',
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
                          child: TextButton(
                              onPressed: () async {
                                final response1 = await Supabase.instance.client
                                    .from('Utilisateurs')
                                    .select('email,id,photoProfila,num_tel')
                                    .eq('nom', emailController.text)
                                    .execute();
                                String ema = '';
                                String? d = '';
                                String f = '';
                                int? phon = 0;

                                if (response1.status == 200) {
                                  final data = response1.data;

                                  for (var row in data as List<dynamic>) {
                                    ema = row['email'] as String;
                                    d = row['id'] as String;
                                    phon = row['num_tel'] as int?;
                                    // f = row['photoProfila'] as String;
                                  }
                                  // // }
                                  // if (data.length > 0) {
                                  //   final ema = data[0]['email'].toString();
                                  //   // Use email value

                                  final response = await Supabase
                                      .instance.client.auth
                                      .signInWithPassword(
                                    email: ema,
                                    password: passwordController.text,
                                  );

                                  if (response.user != null) {
                                    conn us = new conn();
                                    us.setconn(d, emailController.text, ema, f,
                                        phon.toString());

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'le mot de passe est incorrect'),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'le nom d\'utiliateur est incorrecte ')),
                                  );
                                  // No results found
                                }

                                // Navigator.pop(context);
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (context) {
                                //   return MyApp(isLogin: true);
                                // }));
                              },
                              child: Text(
                                "connectez-vous",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFF2697FF),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                        ),
                      ],
                    ),
                  ),
                ),

                //End of Center Card
                //Start of outer card
                const SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                  delay: 1,
                  child: GestureDetector(
                    onTap: (() {
                      // Navigator.pop(context);
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return ForgotPasswordScreen();
                      // }));
                    }),
                    child: Text("Can't Log In?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Vous n'avez pas de compte ?  ",
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screen()));
                        },
                        child: Text("Créez votre compte",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)
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
