import 'package:flutter/material.dart';
import 'package:mono_learn/tools/database_service.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, dbService, child) {
        return Center(
          child: dbService.questionsList.isEmpty
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Text(
                      dbService.questionText(),
                    ),
                    Text(
                      dbService.score.toString(),
                    ),
                    Button(
                        buttonText: dbService.getOptionA(),
                        onPressed: () {
                          dbService.checkAnswer(dbService.getOptionA());
                          dbService.next();
                        },
                        color: kMainColor,
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        borderRadius: 8,
                        buttonHeight: 20),
                    Button(
                        buttonText: dbService.getOptionB(),
                        onPressed: () {
                          dbService.checkAnswer(dbService.getOptionB());
                          dbService.next();
                        },
                        color: kMainColor,
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        borderRadius: 8,
                        buttonHeight: 20),
                    Button(
                        buttonText: dbService.getOptionC(),
                        onPressed: () {
                          dbService.checkAnswer(dbService.getOptionC());
                          dbService.next();
                        },
                        color: kMainColor,
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        borderRadius: 8,
                        buttonHeight: 20),
                  ],
                ),
        );
      },
    );
  }
}
