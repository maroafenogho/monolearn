import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? firebaseUser;
  String firstName = '';
  String lastname = '';
  String username = '';
  String email = '';
  String phone = '';
  String profileUrl = '';
  String interests = '';
  late String userId;
  String? firstname;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void _setUpFirebaseAuth() {
    User? firebaseUser = auth.currentUser;
    auth.authStateChanges().listen((event) {
      if (firebaseUser == null) {}
    });
  }

  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  void getData() async {
    await dbRef
        .child('users')
        .child(auth.currentUser!.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, value) {
        setState(() {
          firstName = values['firstname'];
          lastname = values['lastname'];
          username = values['username'];
          email = values['email'];
          phone = values['phone'];
          profileUrl = values['profile_photo'];
          interests = values['interests'];
          // username = auth.currentUser?.displayName as String;
        });
        print(values['firstname']);
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileUrl == ''
                ? Image.asset('images/profile_photo.jpg')
                : Image.network(
                    profileUrl,
                    height: 120,
                    width: 120,
                    // fit: BoxFit.contain,
                  ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Name:',
                      style: kTextHeaderStyle,
                    )),
                Expanded(flex: 4, child: Text('$firstName $lastname')),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Username:',
                      style: kTextHeaderStyle,
                    )),
                Expanded(flex: 4, child: Text(username)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Email:',
                      style: kTextHeaderStyle,
                    )),
                Expanded(flex: 4, child: Text(email)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Phone:',
                      style: kTextHeaderStyle,
                    )),
                Expanded(flex: 4, child: Text(phone)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Interests:',
                      style: kTextHeaderStyle,
                    )),
                Expanded(flex: 4, child: Text(interests)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
