import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mono_learn/tools/question.dart';
import 'package:flutter/foundation.dart';
import 'package:mono_learn/tools/user_detail.dart';

class DatabaseService extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase.instance;
  List<Question> questionsList = [];
  var questionNumber = 0;
  int score = 0;
  String userName = '';
  bool isVisible = false;
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserDetails? userDetails;

  void loading() {
    isLoading = !isLoading;
    print(isLoading);
    notifyListeners();
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
    print('you  dey see am?');
  }

  void next() {
    if (questionNumber < questionsList.length - 1) {
      questionNumber++;
      print(questionsList);
    }
    notifyListeners();
  }

  String getOptionA() {
    return questionsList[questionNumber].optionA;
  }

  String getOptionB() {
    return questionsList[questionNumber].optionB;
  }

  String getOptionC() {
    return questionsList[questionNumber].optionC;
  }

  String getAnswer() {
    return questionsList[questionNumber].answer;
  }

  checkAnswer(String selected) {
    if (selected == questionsList[questionNumber].answer) {
      score++;
      print(score);
      notifyListeners();
    }
    next();
  }

  String questionText() {
    return questionsList[questionNumber].questionText;
  }

  Future<List<Question>> getQuestions() async {
    var ref =
        firebaseDatabase.reference().child('questions').child('fractions');
    await ref.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      questionsList.clear();
      for (var val in snapshot.value) {
        questionsList.add(Question.fromMap(val));
        notifyListeners();
      }
    });
    return questionsList;
  }

  getDetails() async {
    await firebaseDatabase
        .reference()
        .child('users')
        .child(auth.currentUser!.uid)
        .once()
        .then((value) {
      Map<dynamic, dynamic> values = value.value;
      values.forEach((key, value) {
        userName = values['username'];
        notifyListeners();
      });
    });
  }
}
