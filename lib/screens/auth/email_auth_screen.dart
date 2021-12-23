import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/phone_auth_screen.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:mono_learn/widgets/button_login.dart';

import '../../widgets/edit_text.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);
  final style = ElevatedButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    primary: Color(0xff3f3d56),
    elevation: 10.0,
    padding: EdgeInsets.all(10),
  );

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
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

  void sendVerEmail() {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      firebaseUser.sendEmailVerification().whenComplete(() {
        showSnackBar('Email Verification sent');
      });
    }
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
                                  labelText: 'Email address *',
                                  labelStyle: kEditTextHint,
                                  enabledBorder: kOutlineBorder,
                                  focusedBorder: kOutlineBorder,
                                ),
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
                                                  .createUserWithEmailAndPassword(
                                                      email: email,
                                                      password: password)
                                                  .then((value) {
                                                auth.currentUser
                                                    ?.updateDisplayName(
                                                        userName)
                                                    .then((value) {
                                                  auth.currentUser
                                                      ?.updatePhotoURL(
                                                          profileImageLink);
                                                  firebaseDatabase
                                                      .reference()
                                                      .child('users')
                                                      .child(
                                                          auth.currentUser!.uid)
                                                      .set(<String, String>{
                                                    'firstname': firstName,
                                                    'lastname': lastName,
                                                    'email': email,
                                                    'username': userName,
                                                    'interests': interests,
                                                    'profile_photo':
                                                        profileImageLink,
                                                    'phone': phone,
                                                    'uid': auth.currentUser!.uid
                                                  }).then((user) {
                                                    showSnackBar(
                                                        'User registration successful');
                                                    sendVerEmail();
                                                    auth.signOut();
                                                    gotoLoginPage(context);
                                                  });
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                                print(value.toString());
                                              }).onError((error, stackTrace) {
                                                showSnackBar(error.toString());
                                                setState(() {
                                                  isLoading = false;
                                                });
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
                                buttonText: 'Sign-up with phone instead',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PhoneAuthScreen(),
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

  void gotoLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }
}
