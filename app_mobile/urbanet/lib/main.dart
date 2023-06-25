import 'package:flutter/material.dart';
import 'wigetpages.dart/typesignalement.dart';
import 'package:urbanet/wigetpages.dart/home.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Services/notifi_service.dart';
import 'package:urbanet/packag.dart/photo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:urbanet/screen/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cukaewahtyvircempvpm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1a2Fld2FodHl2aXJjZW1wdnBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODE3NDA4ODQsImV4cCI6MTk5NzMxNjg4NH0.rhqXefu1VTn7d2w965NLgMM1qDh-OUCjzZdY9ovU2Zs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Screen(),
      //  MyHomePage(),
    );
  }
}
