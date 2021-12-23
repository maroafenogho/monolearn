import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isVisible = false;
  bool? isLoading = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void showSnackBar(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  String resetEmail = "";
  String warning = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff263238),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Enter your email address",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                cursorColor: kMainColor,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                onChanged: (typedText) {
                  resetEmail = typedText;
                  setState(() {
                    warning = '';
                  });
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
              warning == ''
                  ? Container()
                  : Text(
                      warning,
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
              ButtonLogin(
                buttonChild: isLoading == false
                    ? Text(
                        'Reset',
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
                  if (resetEmail.isEmpty) {
                    setState(() {
                      warning = 'Please fill in your email';
                    });
                  }
                  if (resetEmail.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await auth
                          .sendPasswordResetEmail(email: resetEmail)
                          .then((result) {
                        showSnackBar('Reset link sent');
                        Navigator.pop(context);
                        setState(() {
                          isLoading = false;
                        });
                      }).onError((error, stackTrace) {
                        showSnackBar(error.toString());
                        Navigator.pop(context);
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
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
