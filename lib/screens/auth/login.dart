import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/phone_login.dart';
import 'package:mono_learn/screens/auth/resend_verification.dart';
import 'package:mono_learn/screens/auth/reset_password.dart';
import 'package:mono_learn/screens/dash_area/dashboard.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';

import '../../widgets/edit_text.dart';
import 'email_auth_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String email = "";
  String password = "";

  bool? isLoading = false;

  void _setUpFirebaseAuth() {
    User? firebaseUser = auth.currentUser;
    auth.authStateChanges().listen((event) {
      if (firebaseUser != null) {
        showSnackBar('Authenticated with ${firebaseUser.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setUpFirebaseAuth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Login',
                  textAlign: TextAlign.start,
                  style: kHeaderStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome back to MonoLearn. please log in',
                  textAlign: TextAlign.start,
                  style: kWhiteText,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              cursorColor: kMainColor,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (typedText) {
                                email = typedText;
                              },
                              style: const TextStyle(
                                color: kMainColor,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: kMainColor,
                                ),
                                labelText: 'Email address',
                                labelStyle: kEditTextHint,
                                enabledBorder: kOutlineBorder,
                                focusedBorder: kOutlineBorder,
                              ),
                            ),
                            TFormField(
                              onChanged: (typedText) {
                                password = typedText;
                              },
                              labelText: 'Password',
                              textCapitalization: TextCapitalization.none,
                              obscure: isVisible ? false : true,
                              inputType: TextInputType.text,
                              icon: Icons.lock,
                              suffixIcon: isVisible == false
                                  ? Icons.visibility_off_sharp
                                  : Icons.visibility_sharp,
                              onTap: () {
                                setState(() {
                                  toggleVisibility();
                                });
                              },
                            ),
                            ButtonLogin(
                              buttonChild: isLoading == false
                                  ? Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                              onPressed: () async {
                                if (email.isEmpty || password.isEmpty) {
                                  showSnackBar("Please fill required fields");
                                }
                                if (email.isNotEmpty && password.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    await auth
                                        .signInWithEmailAndPassword(
                                            email: email, password: password)
                                        .then((result) {
                                      if (result.user!.emailVerified) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Dashboard(),
                                          ),
                                        );
                                        showSnackBar('Login Successful');
                                      } else {
                                        auth.signOut();
                                        showSnackBar("Please Verify Email");
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }).onError((error, stackTrace) {
                                      showSnackBar(error.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  } catch (e) {
                                    showSnackBar(e.toString());
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              color: kMainColor,
                              borderColor: kMainColor,
                              buttonHeight: 40,
                              borderRadius: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: ResetPassword(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: kMainColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: ResendVerificationScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Resend verification link',
                                    style: TextStyle(
                                      color: kMainColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                'New User? Sign up',
                                style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PhoneLogin(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login with phone',
                                style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
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
