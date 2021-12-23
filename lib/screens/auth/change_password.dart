import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';
import 'package:mono_learn/widgets/edit_text.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
  String resendEmail = "";
  String currentPassword = "";
  String confirmPassword = "";
  String newPassword = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  void _changePassword(String currentPassword, String newPassword) async {
    final user = auth.currentUser;
    final credential = EmailAuthProvider.credential(
        email: user!.email as String, password: currentPassword);
    try {
      await user.reauthenticateWithCredential(credential).then((value) {
        user.updatePassword(newPassword);
        showSnackBar('Password updated');
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        showSnackBar(error.toString());
        Navigator.pop(context);
        setState(() {
          isLoading = false;
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
                  currentPassword = typedText;
                  setState(() {
                    warning = '';
                  });
                },
                labelText: 'Current Password',
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
              TFormField(
                onChanged: (typedText) {
                  newPassword = typedText;
                },
                labelText: 'New Password',
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
              TFormField(
                onChanged: (typedText) {
                  setState(() {
                    if (newPassword == typedText || typedText == '') {
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
                  if (currentPassword.isEmpty) {
                    setState(() {
                      warning = 'Please fill in your current password';
                    });
                  }
                  if (newPassword.isNotEmpty &&
                      currentPassword.isNotEmpty &&
                      newPassword == confirmPassword) {
                    setState(() {
                      isLoading = true;
                    });
                    _changePassword(currentPassword, newPassword);
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
