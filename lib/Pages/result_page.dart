import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/categories_model.dart';
import '../Models/difficulty_model.dart';
import '../Provider/quiz_state.dart';

Map<int, String> results = {};

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
    required this.categories,
    required this.difficulty,
  }) : super(key: key);
  final Categories categories;
  final Difficulty difficulty;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isSaved = false;

  Future<void> saveResult(int rightAnswer, int wrongAnswer, context) async {
    final docResults = FirebaseFirestore.instance.collection("results");
    final jsonBody = {
      "category": EnumToString.convertToString(widget.categories),
      "difficulty": EnumToString.convertToString(widget.difficulty),
      "date_time": DateTime.now(),
      "right-answer": rightAnswer,
      "wrong-answer": wrongAnswer,
    };
    try {
      await docResults.add(jsonBody);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: const [
              Icon(Icons.done, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('You saved a result!'))
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
      setState(() => isSaved = true);
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: const [
              Icon(Icons.done, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Something went wrong!'))
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width * .05;
    final width = MediaQuery.of(context).size.width * 0.6;
    final quizState = Provider.of<QuizState>(context);
    int rightAnswer = 0;
    int wrongAnswer = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          //Table with results
          resultTable(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Save button in FireStore
              isSaved
                  ? Container()
                  : saveButton(width, rightAnswer, wrongAnswer, context),
              //Restart button
              restartButton(quizState, width),
              SizedBox(height: height),
            ],
          ),
        ],
      ),
    );
  }

  Widget resultTable() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(),
        children: [
          for (int i = 0; i < results.length; i++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      'Question №${i + 1}',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      results[i + 1]!,
                      style: TextStyle(
                        color: results[i + 1] == "Right"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget saveButton(double width, int rightAnswer, int wrongAnswer, context) {
    return TextButton(
      child: SizedBox(
        width: width,
        child: Card(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.save_alt, color: Colors.white),
                ),
                Text(
                  'Save a result!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onPressed: () async {
        for (int i = 0; i < results.length; i++) {
          if (results[i + 1] == "Right") {
            rightAnswer++;
          } else {
            wrongAnswer++;
          }
        }
        await saveResult(rightAnswer, wrongAnswer, context);
      },
    );
  }

  Widget restartButton(QuizState quizState, double width) {
    return TextButton(
      child: SizedBox(
        width: width,
        child: Card(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.restart_alt, color: Colors.white),
                  ),
                  Text(
                    'Restart Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ),
      ),
      onPressed: () {
        results = {};
        quizState.setStateBegin();
      },
    );
  }
}
