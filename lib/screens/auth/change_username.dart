import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';
import 'package:mono_learn/widgets/edit_text.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  String username = '';
  String warning = '';
  bool? isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  void showSnackBar(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
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
                  username = typedText;
                  setState(() {
                    warning = '';
                  });
                },
                textCapitalization: TextCapitalization.none,
                labelText: 'New Username',
                obscure: false,
                inputType: TextInputType.emailAddress,
                icon: Icons.account_circle,
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
                onPressed: () {
                  if (username.isEmpty) {
                    setState(() {
                      warning = 'Username cannot be empty';
                    });
                  } else {
                    try {
                      //update username node in firebase database
                      auth.currentUser
                          ?.updateDisplayName(username)
                          .then((value) {
                        FirebaseDatabase.instance
                            .reference()
                            .child('users')
                            .child(auth.currentUser!.uid)
                            .update(<String, String>{
                          'interests': username,
                        }).then((value) {
                          Navigator.pop(context);
                          showSnackBar('Username updated successfully');
                          setState(() {
                            isLoading = false;
                          });
                        }).onError((error, stackTrace) {
                          showSnackBar(error.toString());
                        });
                      }).onError((error, stackTrace) {
                        showSnackBar(error.toString());
                      });
                    } catch (e) {}
                    setState(() {
                      isLoading = true;
                    });
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
