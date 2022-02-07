import 'package:flutter/material.dart';
import 'package:mono_learn/tools/database_service.dart';
import 'package:mono_learn/utils/constants.dart';
import 'package:mono_learn/widgets/button.dart';
import 'package:provider/provider.dart';

class Buddies extends StatefulWidget {
  const Buddies({Key? key}) : super(key: key);

  @override
  State<Buddies> createState() => _BuddiesState();
}

class _BuddiesState extends State<Buddies> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService dbService = Provider.of<DatabaseService>(context);

    return Scaffold(
      body: Center(
        child: dbService.questionsList.isEmpty
            ? Container(
                child: CircularProgressIndicator(),
                color: Colors.white,
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(dbService.questionText()),
                  Button(
                      buttonText: 'Next',
                      onPressed: () {
                        dbService.next();
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
