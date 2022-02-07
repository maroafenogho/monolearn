import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:mono_learn/tools/question.dart';

class Fractions extends ChangeNotifier {
  String questionText = '';
  String optionA = '';
  String optionB = '';
  String optionC = '';
  String answer = '';
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  List<Question> question = [];
  int questionNumber = 0;

  void next() {
    questionNumber++;
    notifyListeners();
    print(questionNumber);
  }

  String getQuestionText() {
    return question[questionNumber].questionText;
  }

  Future<void> getData() async {
    await dbRef
        .child('questions')
        .child('fractions')
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var val in dataSnapshot.value) {
        final q = Question(
          val['question'],
          val['option_a'],
          val['option_b'],
          val['option_c'],
          val['answer'],
        );
        question.add(q);
        notifyListeners();
        print(question[0].questionText);
      }
    });
  }
}
