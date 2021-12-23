import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button_login.dart';

class UpdateImage extends StatefulWidget {
  const UpdateImage({Key? key}) : super(key: key);

  @override
  _UpdateImageState createState() => _UpdateImageState();
}

class _UpdateImageState extends State<UpdateImage> {
  String profileImageUrl = '';
  String warning = '';
  bool? isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  late File _file;

  void showSnackBar(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
  }

  Future<String> uploadImage(File image) async {
    String fileName = auth.currentUser!.uid;
    Reference storageRef =
        FirebaseStorage.instance.ref().child('upload/$fileName');
    await storageRef.putFile(image).then((p0) {
      showSnackBar('Successfully uploaded image');
    });
    profileImageUrl = await storageRef.getDownloadURL();
    return profileImageUrl;
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
              GestureDetector(
                child: Icon(
                  Icons.arrow_circle_down_outlined,
                  size: 50.0,
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    if (pickedFile != null) {
                      setState(() {
                        _file = File(pickedFile.path);
                      });
                    } else {
                      showSnackBar('No image selected');
                    }
                  });
                },
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
                onPressed: () async {
                  try {
                    String fileName = auth.currentUser!.uid;
                    Reference storageRef = FirebaseStorage.instance
                        .ref()
                        .child('upload/$fileName');
                    await storageRef.putFile(_file).then((p0) {
                      showSnackBar('Successfully uploaded image');
                    });
                    profileImageUrl = await storageRef.getDownloadURL();
                    FirebaseDatabase.instance
                        .reference()
                        .child('users')
                        .child(auth.currentUser!.uid)
                        .update(<String, String>{
                      'profile_photo': profileImageUrl,
                    }).then((value) {
                      auth.currentUser?.updatePhotoURL(profileImageUrl);
                      Navigator.pop(context);
                      showSnackBar('database link updated');
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
