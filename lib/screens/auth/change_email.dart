import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';
import 'package:mono_learn/widgets/edit_text.dart';

import 'login.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
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

  String warning = "";
  String currentEmail = "";
  String password = "";
  String newEmail = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  void _changeEmail(String currentEmail, String newEmail) async {
    final user = auth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: currentEmail, password: password);
    try {
      await user?.reauthenticateWithCredential(credential).then((value) {
        user.updateEmail(newEmail);
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(auth.currentUser!.uid)
            .update(<String, String>{
          'email': newEmail,
        }).then((value) {
          auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
          showSnackBar('Email updated');
          showSnackBar('Please Verify new Email');
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
      });
    } catch (e) {}
  }

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
                "Enter your details",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TFormField(
                onChanged: (typedText) {
                  currentEmail = typedText;
                },
                textCapitalization: TextCapitalization.none,
                labelText: 'Current Email',
                obscure: false,
                inputType: TextInputType.emailAddress,
                icon: Icons.email,
                onTap: () {},
              ),
              TFormField(
                onChanged: (typedText) {
                  newEmail = typedText;
                },
                textCapitalization: TextCapitalization.none,
                labelText: 'New Email',
                obscure: false,
                inputType: TextInputType.emailAddress,
                icon: Icons.email,
                onTap: () {},
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
                        'Change',
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
                  if (currentEmail.isEmpty) {
                    setState(() {
                      warning = 'Please fill in your current email';
                    });
                  }
                  if (newEmail.isNotEmpty && currentEmail.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    _changeEmail(currentEmail, newEmail);
                  } else {
                    showSnackBar('Fill the required fields please');
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
