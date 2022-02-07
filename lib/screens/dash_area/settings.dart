import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/change_email.dart';
import 'package:mono_learn/screens/auth/change_password.dart';
import 'package:mono_learn/screens/auth/change_username.dart';
import 'package:mono_learn/screens/auth/login.dart';
import 'package:mono_learn/tools/auth_service.dart';
import 'package:mono_learn/tools/update_interests.dart';
import 'package:mono_learn/tools/update_profile_image.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Update username'),
            iconColor: kMainColor,
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ChangeUsername(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Update Interests'),
            iconColor: kMainColor,
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: UpdateInterestsScreen(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Update Profile Picture'),
            iconColor: kMainColor,
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: UpdateImage(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Update email'),
            iconColor: kMainColor,
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ChangeEmail(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Change password'),
            iconColor: kMainColor,
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ChangePassword(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text('Logout'),
            iconColor: kMainColor,
            onTap: () {
              authService.signOut().then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  )));
            },
          ),
        ],
      )),
    );
  }
}
