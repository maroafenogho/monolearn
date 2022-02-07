// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/email_auth_screen.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button.dart';

import 'auth/login.dart';
import 'auth/phone_auth_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //dialog to select signUp option
  void registerOption() {
    AlertDialog dialog = AlertDialog(
      content: Container(
          width: 260.0,
          height: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0x00ffffff),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 40.0),
              Button(
                buttonText: 'Register with email',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignUp(),
                    ),
                  );
                },
                color: kBackButton,
                textColor: kMainColor,
                borderColor: kMainColor,
                borderRadius: 0.0,
                buttonHeight: 20.0,
              ),
              const SizedBox(height: 10.0),
              Button(
                buttonText: 'Register with phone',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PhoneAuthScreen(),
                    ),
                  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 16.0,
          top: 42.0,
          end: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Welcome to MonoLearn',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Color(0xff3f3d56),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image(
              image: AssetImage(
                "images/welcome.png",
              ),
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    onPressed: () {
                      registerOption();
                    },
                    color: Colors.white,
                    textColor: kMainColor,
                    borderColor: kMainColor,
                    borderRadius: 5,
                    buttonText: 'Register',
                    buttonHeight: 30,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Button(
                    buttonText: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    },
                    color: kMainColor,
                    textColor: Colors.white,
                    borderColor: kMainColor,
                    buttonHeight: 30,
                    borderRadius: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
