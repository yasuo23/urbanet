import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:urbanet/itemliste.dart/conncet.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';

import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:urbanet/wigetpages.dart/log.dart';
import 'package:urbanet/screen/profile.dart';
import 'package:connectivity/connectivity.dart';

class DialogueFilter extends StatefulWidget {
  @override
  _DialogueFilterState createState() => _DialogueFilterState();
}

class _DialogueFilterState extends State<DialogueFilter> {
  @override
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

  List<typeAa> selectedUserList = [];
  List<Etat> selectedetatList = [];
  String r = "";
  List<String> s = [
    'route bloquée par la neige',
    'nid de poule',
    'fuite d\'eau',
    'route déformé',
    'égout bouchée',
    'ordure abondonnée',
    'animale mort',
    'débris de verre',
    'mobilier endomagé',
    'graffitis sur les murs',
    'chien errant',
    'instalation électrique dangereuse',
    'arbre sur le point de tombé',
  ];
  List<String> e = [
    'en cour',
    'non traitée',
    'traitée',
  ];
  List<typeAa>? select = [];
  List<endrois>? selectedendroie = [];

  List<endrois> listeendrois = [];
  List<String> v = [];
  List<String> c = [];
  var listeValeurs = <List<String?>>[];
  @override
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
    _en();
    _open();
  }

  Future<void> _en() async {
    conn u = conn();
    final response = await Supabase.instance.client
        .from('signalement')
        .select('commune,Quartiers')
        .execute();

    final data = response.data;
    print(data);

    List<endrois> o = [];

    if (response.status == 200) {
      for (var row in data as List<dynamic>) {
        v.add(row['Quartiers']);
        c.add(row['commune']);
        o.add(endrois(commune: row['commune'], quartier: row['Quartiers']));
      }

      o = o.toSet().toList();
      print(o);
      v = v.toSet().toList();
      c = c.toSet().toList();
      print(v);
      print(c);
    }
    print(v);
    print(c);
    print(o);
    setState(() {
      c = c;
      v = v;
      listeendrois = o;
    });
  }

  Future<void> _open() async {
    conn u = conn();
    final response = await Supabase.instance.client
        .from('signalement')
        .select('ids,type,etat,commune,Quartiers')
        // .in_('type', s)
        .in_('type', [
      'route bloquée par la neige',
      'nid de poule',
      'fuite d\'eau',
      'route déformé',
      'égout bouchée',
      'ordure abondonnée',
      'animale mort',
      'débris de verre',
      'mobilier endomagé',
      'graffitis sur les murs',
      'chien errant',
      'instalation électrique dangereuse',
      'arbre sur le point de tombé',
    ]).in_('etat', [
      'en cour',
      'non traitée',
      'traitée',
    ]).execute();
    final data = response.data;
    print(data);
    int q;
    var o = <int>[];

    if (response.status == 200) {
      for (var row in data as List<dynamic>) {
        q = row['ids'] as int;
        o.add(q);
      }
    }
    print(data);
    final response1 = await Supabase.instance.client
        .from('multimedia')
        .select('img,video,description,dateS,ids')
        .in_('ids', o)
        .eq('idu', u.userId)
        .execute();
    print('h');

    // Define the table names

    String? d = '';
    String? d1 = '';
    String? d2 = '';
    String? d3 = '';
    String? d4 = '';
    String? d5 = '';
    String? d6 = '';
    String? d7 = '';
    String? d8 = '';

    String f = '';
    final data2 = response1.data;
    print(data2);
    if (response1.status == 200) {
      for (var row in data2 as List<dynamic>) {
        for (var row2 in data as List<dynamic>) {
          if (row['ids'] == row2['ids']) {
            d = row2['etat'] as String?;
            d1 = row2['type'] as String?;
            d2 = row['dateS'] as String?;
            d3 = row2['DateT'] as String?;
            d4 = row['img'] as String?;
            d5 = row['video'] as String?;
            d6 = row['description'] as String?;
            d7 = row2['commune'] as String?;
            d8 = row2['Quartiers'] as String?;
            listeValeurs.add([d, d1, d2, d3, d4, d5, d6, d7, d8]);
          }
        }
      }
      print(listeValeurs);
    }

    setState(() {
      listeValeurs = listeValeurs;
    });
  }

  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<typeAa>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Veuillez sélectionner le type',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.typeS,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.typeS.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedUserList.clear();
          selectedUserList = List.from(list!);
        });
        {
          s.clear();
          print(selectedUserList!.length);
          for (var i in selectedUserList as List<typeAa>) {
            s.add(i.typeS);
            print("${i.typeS}");
          }

          s = s.toSet().toList();
          print(r);
          print(e);
          print(s);

          listeValeurs.clear();
          conn u = conn();
          final response = await Supabase.instance.client
              .from('signalement')
              .select('ids,type,etat,commune,Quartiers')
              // .in_('type', s)
              .in_('type', s)
              .in_('etat', e)
              .in_('Quartiers', v)
              .in_('commune', c)
              .execute();
          final data = response.data;
          print(data);
          int q;
          var o = <int>[];

          if (response.status == 200) {
            for (var row in data as List<dynamic>) {
              q = row['ids'] as int;
              o.add(q);
            }
          }
          print(data);
          final response1 = await Supabase.instance.client
              .from('multimedia')
              .select('img,video,description,dateS,ids')
              .in_('ids', o)
              .eq('idu', u.userId)
              .execute();
          print('h');

          // Define the table names

          String? d = '';
          String? d1 = '';
          String? d2 = '';
          String? d3 = '';
          String? d4;
          String? d5 = '';
          String? d6 = '';
          String? d7 = '';
          String? d8 = '';

          String f = '';
          final data2 = response1.data;
          print(data2);
          if (response1.status == 200) {
            for (var row in data2 as List<dynamic>) {
              for (var row2 in data as List<dynamic>) {
                if (row['ids'] == row2['ids']) {
                  d = row2['etat'] as String?;
                  d1 = row2['type'] as String?;
                  d2 = row['dateS'] as String?;
                  d3 = row2['DateT'] as String?;
                  d4 = row['img'] as String?;
                  d5 = row['video'] as String?;
                  d6 = row['description'] as String?;
                  d7 = row2['commune'] as String?;
                  d8 = row2['Quartiers'] as String?;
                  listeValeurs.add([d, d1, d2, d3, d4, d5, d6, d7, d8]);
                }
              }
            }
            print(listeValeurs);
            setState(() {
              listeValeurs = listeValeurs;
            });
          }
        }

        Navigator.pop(context);
      },
    );
  }

  Future<void> _openFilterDialog3() async {
    await FilterListDialog.display<endrois>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'sélectionner l\'endroit',
      height: 500,
      listData: listeendrois,
      selectedListData: selectedendroie,
      choiceChipLabel: (item) => item!.commune + " , " + item.quartier,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.commune.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedendroie!.clear();
          selectedendroie = List.from(list!);
        });
        {
          v.clear();
          c.clear();
          print(selectedendroie!.length);
          for (var i in selectedendroie as List<endrois>) {
            v.add(i.quartier);
            c.add(i.commune);
          }

          v = v.toSet().toList();
          c = c.toSet().toList();
          print(r);
          print(e);
          print(s);

          listeValeurs.clear();
          conn u = conn();
          final response = await Supabase.instance.client
              .from('signalement')
              .select('ids,type,etat,commune,Quartiers')
              // .in_('type', s)
              .in_('type', s)
              .in_('etat', e)
              .in_('Quartiers', v)
              .in_('commune', c)
              .execute();
          final data = response.data;
          print(data);
          int q;
          var o = <int>[];

          if (response.status == 200) {
            for (var row in data as List<dynamic>) {
              q = row['ids'] as int;
              o.add(q);
            }
          }
          print(data);
          final response1 = await Supabase.instance.client
              .from('multimedia')
              .select('img,video,description,dateS,ids')
              .in_('ids', o)
              .eq('idu', u.userId)
              .execute();
          print('h');

          // Define the table names

          String? d = '';
          String? d1 = '';
          String? d2 = '';
          String? d3 = '';
          String? d4;
          String? d5 = '';
          String? d6 = '';
          String? d7 = '';
          String? d8 = '';

          String f = '';
          final data2 = response1.data;
          print(data2);
          if (response1.status == 200) {
            for (var row in data2 as List<dynamic>) {
              for (var row2 in data as List<dynamic>) {
                if (row['ids'] == row2['ids']) {
                  d = row2['etat'] as String?;
                  d1 = row2['type'] as String?;
                  d2 = row['dateS'] as String?;
                  d3 = row2['DateT'] as String?;
                  d4 = row['img'] as String?;
                  d5 = row['video'] as String?;
                  d6 = row['description'] as String?;
                  d7 = row2['commune'] as String?;
                  d8 = row2['Quartiers'] as String?;
                  listeValeurs.add([d, d1, d2, d3, d4, d5, d6, d7, d8]);
                }
              }
            }
            print(listeValeurs);
            setState(() {
              listeValeurs = listeValeurs;
            });
          }
        }

        Navigator.pop(context);
      },
    );
  }

  Future<void> _openFilterDialog2() async {
    await FilterListDialog.display<Etat>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'sélectionner l\'état',
      height: 500,
      listData: etatList,
      selectedListData: selectedetatList,
      choiceChipLabel: (item) => item!.etat,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.etat.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        setState(() {
          selectedetatList.clear();
          selectedetatList = List.from(list!);
        });
        {
          e.clear();
          print(selectedUserList!.length);

          for (var j in selectedetatList as List<Etat>) {
            print("${j.etat}");
            e.add(j.etat);
          }
          e = e.toSet().toList();

          print(s);

          listeValeurs.clear();
          conn u = conn();
          final response = await Supabase.instance.client
              .from('signalement')
              .select('ids,type,etat,commune,Quartiers')
              // .in_('type', s)
              .in_('type', s)
              .in_('etat', e)
              .in_('Quartiers', v)
              .in_('commune', c)
              .execute();
          final data = response.data;
          print(data);
          int q;
          var o = <int>[];

          if (response.status == 200) {
            for (var row in data as List<dynamic>) {
              q = row['ids'] as int;
              o.add(q);
            }
          }
          print(data);
          final response1 = await Supabase.instance.client
              .from('multimedia')
              .select('img,video,description,dateS,ids')
              .in_('ids', o)
              .eq('idu', u.userId)
              .execute();
          print('h');

          // Define the table names

          String? d = '';
          String? d1 = '';
          String? d2 = '';
          String? d3 = '';
          String? d4;
          String? d5 = '';
          String? d6 = '';
          String? d7 = '';
          String? d8 = '';

          String f = '';
          final data2 = response1.data;
          print(data2);
          if (response1.status == 200) {
            for (var row in data2 as List<dynamic>) {
              for (var row2 in data as List<dynamic>) {
                if (row['ids'] == row2['ids']) {
                  d = row2['etat'] as String?;
                  d1 = row2['type'] as String?;
                  d2 = row['dateS'] as String?;
                  d3 = row2['DateT'] as String?;
                  d4 = row['img'] as String?;
                  d5 = row['video'] as String?;
                  d6 = row['description'] as String?;
                  d7 = row2['commune'] as String?;
                  d8 = row2['Quartiers'] as String?;
                  listeValeurs.add([d, d1, d2, d3, d4, d5, d6, d7, d8]);
                }
              }
            }
            print(listeValeurs);
            setState(() {
              listeValeurs = listeValeurs;
            });
          }
        }

        Navigator.pop(context);
      },
    );
  }

  int currentIndexBottomBar = 0;
  int currentIndexSwiperHome = 0;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
    Icons.output_sharp
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('trouvez vos ancient signalement'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Color.fromRGBO(224, 215, 255, 1),
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
          image: AssetImage(
            "images/back.jpg",
          ),
          fit: BoxFit.cover,
        )),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 10,
            ),
            //  ListView(scrollDirection: Axis.horizontal,

            Container(
              height: 30,
              width: 160,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text('  Filtrez les signalements par type',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 30,
              width: 160,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog2();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(' Filtrez les signalements par état',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(126, 4, 18, 127),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: InkWell(
                  onTap: () {
                    _openFilterDialog3();
                  },
                  child: Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text('  Filtrez les signalements par endroits',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway')),
                  ])),
            ),
            SizedBox(
              height: 30,
            ),

            if (listeValeurs == null ||
                selectedUserList == null ||
                listeValeurs.isEmpty)
              const Expanded(
                  child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0, bottom: 31.0),
                  child: Text(
                    'aucun signalement n\'est selectionée',
                    style: TextStyle(
                        color: Color.fromARGB(255, 56, 72, 160),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway'),
                  ),
                ),
              ))
            else
              for (var ro in listeValeurs as List<List<String?>>)
                Column(children: [
                  Container(
                      width: 320,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                          color: Color.fromARGB(154, 255, 254, 255)),
                      child: Row(children: [
                        Container(
                          height: 130,
                          width: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage("${ro[4]}"),
                            ),
                          ),
                          /* add child content here */
                        ),

                        Container(
                          // child: Padding(
                          // padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ${ro[1]}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 58, 79, 195),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "état:  ${ro[0]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "date du signalement:  ${ro[2]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              if (ro[3] != null)
                                Text(
                                  "date du traitement:  ${ro[3]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              Text(
                                "description:  ${ro[6]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "commune: ${ro[7]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Quartiers:  ${ro[8]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                            // ),
                          ),
                        ),
                        // Image.asset("${ro[4]}"),

                        // Column(children: [

                        //   Text("etat:  ${ro[0]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   Text("type:  ${ro[1]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   Text("date de signalement:  ${ro[2]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   if (ro[3] != null)
                        //     Text("date de traitement:  ${ro[3]}",
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 15.0,
                        //             fontWeight: FontWeight.w600,
                        //             fontFamily: 'Raleway')),
                        //   Text("description:  ${ro[6]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   Text("commune: ${ro[7]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   Text("Quartiers:  ${ro[8]}",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: 'Raleway')),
                        //   SizedBox(
                        //     height: 20,
                        //   )
                        // ])
                      ])),
                  SizedBox(
                    height: 20,
                  )
                ])
            // Expanded(
            //   child: ListView.separated(
            //     itemBuilder: (context, index) {
            //       return ListTile(

            //         // title: Text(selectedUserList![index].typeS! +
            //         //     selectedUserList![index].title!),
            //       );
            //     },
            //     separatorBuilder: (context, index) => const Divider(),
            //     itemCount: selectedUserList!.length,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class typeAa {
  final String image;
  final String title;
  final String typeS;

  typeAa({required this.image, required this.title, required this.typeS});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<typeAa> userList = [
  typeAa(
    image: 'images/icy.png',
    title: 'route',
    typeS: 'route bloquée par la neige',
  ),
  typeAa(
    image: 'images/pothole.png',
    title: 'route',
    typeS: 'nid de poule',
  ),
  typeAa(
    image: 'images/flood.png',
    title: 'fuite d\'eau  ',
    typeS: 'fuite d\'eau',
  ),
  typeAa(
    image: 'images/street.png',
    title: 'route déformé ',
    typeS: 'route déformé',
  ),
  typeAa(
    image: 'images/urban.png',
    title: 'égout bouchée',
    typeS: 'égout bouchée',
  ),
  typeAa(
    image: 'images/rubbish.png',
    title: 'ordure abondonnée  ',
    typeS: 'ordure abondonnée',
  ),
  typeAa(
    image: 'images/dead.png',
    title: 'animale mort   ',
    typeS: 'animale mort',
  ),
  typeAa(
    image: 'images/broken-bottle.png',
    title: 'débris de verre',
    typeS: 'débris de verre',
  ),
  typeAa(
    image: 'images/bench.png',
    title: 'mobilier endomagé',
    typeS: 'mobilier endomagé',
  ),
  typeAa(
    image: 'images/wall.png',
    title: 'chien errant',
    typeS: 'graffitis sur les murs',
  ),
  typeAa(
    image: 'images/dog.png',
    title: 'chien errant',
    typeS: 'chien errant',
  ),
  typeAa(
    image: 'images/electrical-panel.png',
    title: 'instalation électrique dangereuse',
    typeS: 'instalation électrique dangereuse',
  ),
  typeAa(
    image: 'images/fallen.png',
    title: 'chien errant',
    typeS: 'arbre sur le point de tombé',
  ),
];

class Etat {
  final String etat;

  Etat({required this.etat});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<Etat> etatList = [
  Etat(
    etat: 'en cour',
  ),
  Etat(
    etat: 'non traitée',
  ),
  Etat(
    etat: 'traitée',
  ),
];

class endrois {
  final String commune;
  final String quartier;

  endrois({required this.commune, required this.quartier});
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is endrois &&
          runtimeType == other.runtimeType &&
          commune == other.commune &&
          quartier == other.quartier;

  @override
  int get hashCode => commune.hashCode ^ quartier.hashCode;
}
