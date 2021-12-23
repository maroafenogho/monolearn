import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mono_learn/screens/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MonoLearn',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 45,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageLogin);
    } else {
      // First time
      prefs.setBool('first_time', false);
      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageWel() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => WelcomePage()));
    // Navigator.of(context).pushReplacementNamed('welcomePage');
  }

  void navigationPageLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

    // Navigator.of(context).pushReplacementNamed('loginPage');
  }
}
