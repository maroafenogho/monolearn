import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';

class UpdateInterestsScreen extends StatefulWidget {
  const UpdateInterestsScreen({Key? key}) : super(key: key);

  @override
  _UpdateInterestsScreenState createState() => _UpdateInterestsScreenState();
}

class _UpdateInterestsScreenState extends State<UpdateInterestsScreen> {
  String interests = '';
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
                "Enter your new interests",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.0,
                ),
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
                  hintText: 'Interests e.g. Music, football, sky diving',
                  labelStyle: kEditTextHint,
                  enabledBorder: kOutlineBorder,
                  focusedBorder: kOutlineBorder,
                ),
              ),
              SizedBox(
                height: 15.0,
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
                        'Update',
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
                  if (interests.isEmpty) {
                    setState(() {
                      warning = 'Username cannot be empty';
                    });
                  } else {
                    try {
                      FirebaseDatabase.instance
                          .reference()
                          .child('users')
                          .child(auth.currentUser!.uid)
                          .update(<String, String>{
                        'interests': interests,
                      }).then((value) {
                        Navigator.pop(context);
                        showSnackBar('Interests updated successfully');
                        setState(() {
                          isLoading = false;
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
