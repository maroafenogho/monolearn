import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/splashscreen.dart';
import 'package:mono_learn/tools/auth_service.dart';
import 'package:mono_learn/tools/database_service.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) =>
            DatabaseService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mono-Learn',
        theme: ThemeData(primaryColor: kMainColor),
        home: SplashScreen(),
      ),
    );
  }
}
