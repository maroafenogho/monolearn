import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mono_learn/tools/question.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/utils/question_files/fractions.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  User? firebaseUser;
  String questionText = '';
  String optionA = '';
  String optionB = '';
  String optionC = '';
  String answer = '';

  late List<Question> question = [];
  late String userId;
  int questionNumber = 0;

  void next() {
    if (questionNumber <= question.length - 1) {
      questionNumber++;
    }
    print(questionNumber);
  }

  void restart() {
    questionNumber = 0;
    print(questionNumber);
    print(question.length);
    print(question[questionNumber].questionText);
  }

  String getQuestionText() {
    return question[questionNumber].questionText;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getData();
  }

  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  Future<List<Question>> getData() async {
    await dbRef
        .child('questions')
        .child('fractions')
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var val in dataSnapshot.value) {
        final q = Question.fromMap(val);

        setState(() {
          question.add(q);
        });
        print(dataSnapshot.value.runtimeType);
      }
    });
    return question;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getQuestionText()),
            Button(
                buttonText: 'Next',
                onPressed: () {
                  setState(() {
                    next();
                  });
                },
                color: kMainColor,
                textColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: 8,
                buttonHeight: 20),
            Button(
                buttonText: 'Restart',
                onPressed: () {
                  setState(() {
                    restart();
                  });
                },
                color: kMainColor,
                textColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: 8,
                buttonHeight: 20)
          ],
        ),
      ),
    );
  }
}
