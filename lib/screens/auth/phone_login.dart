import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/resend_verification.dart';
import 'package:mono_learn/screens/auth/reset_password.dart';
import 'package:mono_learn/screens/dash_area/dashboard.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';

import 'email_auth_screen.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String code;
  late String verCode;
  late String enteredCode;
  String phone = "";

  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
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
                            SizedBox(
                              height: 40.0,
                              child: TextFormField(
                                cursorColor: kMainColor,
                                keyboardType: TextInputType.number,
                                onChanged: (number) {
                                  phone = code + number;
                                  print(phone);
                                },
                                style: const TextStyle(
                                  color: kMainColor,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: CountryCodePicker(
                                    initialSelection: 'NG',
                                    onInit: (cCode) {
                                      code = cCode!.dialCode!;
                                    },
                                    onChanged: (countryCode) {
                                      code = countryCode.dialCode!;
                                      print(code);
                                    },
                                    showDropDownButton: true,
                                    flagWidth: 20.0,
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  hintText: 'Phone Number',
                                  labelStyle: kEditTextHint,
                                  enabledBorder: kOutlineBorder,
                                  focusedBorder: kOutlineBorder,
                                ),
                              ),
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
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await auth
                                      .signInWithPhoneNumber(phone)
                                      .then((result) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Dashboard(),
                                      ),
                                    );
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
