import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/dash_area/dashboard.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:mono_learn/widgets/button_login.dart';
import 'package:mono_learn/widgets/edit_text.dart';

import 'email_auth_screen.dart';
import 'login.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void gotoLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String firstName = "";
  String lastName = "";
  String profileImageLink = "";
  String userName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String interests = "";
  String phone = "";
  String warning = "";
  String warningLength = "";
  bool? isLoading = false;
  late String code;
  late String verCode;
  late String enteredCode;

  void _enterCode() {
    AlertDialog dialog = AlertDialog(
      content: Container(
          width: 260.0,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0x00ffffff),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Enter verification code'),
              SizedBox(height: 15.0),
              TFormField(
                onChanged: (typedText) {
                  verCode = typedText;
                },
                textCapitalization: TextCapitalization.none,
                labelText: 'Verification code',
                obscure: false,
                inputType: TextInputType.number,
                onTap: () {},
              ),
              Button(
                buttonText: 'Register with phone',
                onPressed: () {
                  enteredCode = verCode;
                  Navigator.pop(context);
                },
                color: kBackButton,
                textColor: kMainColor,
                borderColor: kMainColor,
                borderRadius: 0.0,
                buttonHeight: 20.0,
              ),
            ],
          )),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void showSnackBar(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
  }

  void updateData() {
    auth.currentUser?.updateDisplayName(userName).then((value) {
      auth.currentUser?.updatePhotoURL(profileImageLink);
      auth.currentUser?.updateEmail(email);
      firebaseDatabase
          .reference()
          .child('users')
          .child(auth.currentUser!.uid)
          .set(<String, String>{
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'username': userName,
        'interests': interests,
        'profile_photo': profileImageLink,
        'phone': phone,
        'uid': auth.currentUser!.uid
      }).then((user) {
        showSnackBar('User registration successful');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: SafeArea(
        child: Center(
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
                    'Sign Up',
                    textAlign: TextAlign.start,
                    style: kHeaderStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome to MonoLearn. Please tell us about yourself',
                    textAlign: TextAlign.start,
                    style: kWhiteText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TFormField(
                                onChanged: (typedText) {
                                  firstName = typedText;
                                },
                                labelText: 'Firstname  *',
                                obscure: false,
                                inputType: TextInputType.name,
                                icon: Icons.account_circle,
                                onTap: () {},
                                textCapitalization: TextCapitalization.words,
                              ),
                              TFormField(
                                onChanged: (typedText) {
                                  lastName = typedText;
                                },
                                textCapitalization: TextCapitalization.words,
                                labelText: 'Lastname  *',
                                obscure: false,
                                inputType: TextInputType.name,
                                icon: Icons.account_circle,
                                onTap: () {},
                              ),
                              TFormField(
                                onChanged: (typedText) {
                                  userName = typedText;
                                },
                                textCapitalization: TextCapitalization.words,
                                labelText: 'username  *',
                                obscure: false,
                                inputType: TextInputType.name,
                                icon: Icons.account_circle,
                                onTap: () {},
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
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
                                  setState(() {
                                    if (typedText.length >= 6 ||
                                        typedText.isEmpty) {
                                      warningLength = '';
                                    } else {
                                      warningLength =
                                          "Password must be at least 6 characters";
                                    }
                                  });
                                  password = typedText;
                                },
                                textCapitalization: TextCapitalization.none,
                                labelText: 'Password  *',
                                obscure: isVisible ? false : true,
                                inputType: TextInputType.text,
                                icon: Icons.lock,
                                suffixIcon: isVisible
                                    ? Icons.visibility_sharp
                                    : Icons.visibility_off_sharp,
                                onTap: () {
                                  setState(() {
                                    toggleVisibility();
                                  });
                                },
                              ),
                              warningLength == ''
                                  ? Container()
                                  : Text(
                                      warningLength,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                      ),
                                    ),
                              TFormField(
                                onChanged: (typedText) {
                                  setState(() {
                                    if (password == typedText ||
                                        typedText == '') {
                                      warning = '';
                                    } else {
                                      warning = "Passwords don\'t match!";
                                    }
                                  });
                                  confirmPassword = typedText;
                                },
                                textCapitalization: TextCapitalization.none,
                                labelText: 'Confirm Password',
                                obscure: true,
                                inputType: TextInputType.text,
                                icon: Icons.lock,
                                onTap: () {},
                              ),
                              warning.isEmpty
                                  ? Container()
                                  : Text(
                                      warning,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                      ),
                                    ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                minLines: 1,
                                maxLines: 2,
                                cursorColor: kMainColor,
                                keyboardType: TextInputType.multiline,
                                onChanged: (typedText) {
                                  interests = typedText;
                                },
                                style: const TextStyle(
                                  color: kMainColor,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  // prefixIcon: ,
                                  hintText:
                                      'Interests e.g. Music, football, sky diving',
                                  labelStyle: kEditTextHint,
                                  enabledBorder: kOutlineBorder,
                                  focusedBorder: kOutlineBorder,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Button(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.white,
                                        textColor: kMainColor,
                                        borderColor: kMainColor,
                                        borderRadius: 5,
                                        buttonText: 'Back',
                                        buttonHeight: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ButtonLogin(
                                        buttonChild: isLoading == false
                                            ? Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                        onPressed: () async {
                                          if (email.isNotEmpty &&
                                              firstName.isNotEmpty &&
                                              lastName.isNotEmpty &&
                                              password.isNotEmpty &&
                                              password == confirmPassword) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await auth
                                                  .verifyPhoneNumber(
                                                phoneNumber: phone,
                                                verificationCompleted:
                                                    (PhoneAuthCredential
                                                        credential) async {
                                                  await auth
                                                      .signInWithCredential(
                                                          credential)
                                                      .then((value) {
                                                    updateData();
                                                    showSnackBar('Signing in');
                                                  });
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Dashboard(),
                                                    ),
                                                  );
                                                },
                                                verificationFailed:
                                                    (FirebaseAuthException e) {
                                                  if (e.code ==
                                                      'invalid-phone-number') {
                                                    showSnackBar(
                                                        'The provided phone number is not valid.');
                                                  } else {
                                                    showSnackBar(e.code);
                                                  }
                                                },
                                                codeSent: (String
                                                        verificationId,
                                                    int? resendToken) async {
                                                  // Update the UI - wait for the user to enter the SMS code
                                                  _enterCode();
                                                  print(
                                                      'VER ID: $verificationId');
                                                  late String smsCode;
                                                  if (enteredCode != '') {
                                                    smsCode = enteredCode;
                                                    print(enteredCode);
                                                  }
                                                  // Create a PhoneAuthCredential with the code
                                                  PhoneAuthCredential
                                                      credential =
                                                      PhoneAuthProvider
                                                          .credential(
                                                              verificationId:
                                                                  verificationId,
                                                              smsCode: smsCode);

                                                  // Sign the user in (or link) with the credential
                                                  await auth
                                                      .signInWithCredential(
                                                          credential)
                                                      .then((value) {
                                                    updateData();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Dashboard(),
                                                      ),
                                                    );
                                                  });
                                                },
                                                codeAutoRetrievalTimeout:
                                                    (String verificationId) {},
                                              )
                                                  .onError((error, stackTrace) {
                                                showSnackBar(error.toString());
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });

                                              setState(() {
                                                isLoading = false;
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          } else {
                                            showSnackBar(
                                                'Please fill up the required fields');
                                          }
                                        },
                                        color: kMainColor,
                                        borderColor: kMainColor,
                                        buttonHeight: 30,
                                        borderRadius: 5,
                                      ),
                                    ),
                                  ]),
                              TextButton(
                                onPressed: () {
                                  gotoLoginPage(context);
                                },
                                child: Text(
                                  'Already have an account? Login',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: kMainColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Button(
                                buttonText: 'Sign-up with email instead',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignUp(),
                                    ),
                                  );
                                },
                                color: kBackButton,
                                textColor: kMainColor,
                                borderColor: kMainColor,
                                borderRadius: 0.0,
                                buttonHeight: 18.0,
                              )
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
      ),
    );
  }
}
