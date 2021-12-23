import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/splashscreen.dart';
import 'package:mono_learn/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mono-Learn',
      theme: ThemeData(primaryColor: kMainColor),
      home: SplashScreen(),
    );
  }
}
