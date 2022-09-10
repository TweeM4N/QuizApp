import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/result_page.dart';
import '../Models/categories_model.dart';
import '../Models/difficulty_model.dart';
import '../Models/quiz_model.dart';
import '../Provider/quiz_state.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    Key? key,
    required this.categories,
    required this.difficulty,
  }) : super(key: key);
  final Categories categories;
  final Difficulty difficulty;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late List<QuizModel> quizList;
  late int amount;
  bool isBusy = false;
  int questionNumber = 0;

  bool checkAnswerA = false;
  bool checkAnswerB = false;
  bool checkAnswerC = false;
  bool checkAnswerD = false;
  bool checkAnswerE = false;
  bool checkAnswerF = false;

  Future<List<QuizModel>> getQuiz(categories, difficulty) async {
    const apiKey = "4oq4PcMpXlLMWJenk42QSzGCHK0i5u1vOMZNtSsK";
    final queryParameters = {
      "limit": "10",
      "category": EnumToString.convertToString(categories),
      "difficulty": EnumToString.convertToString(difficulty),
    };
    setState(() => isBusy = true);
    try {
      final response = await http.get(
          Uri.https("quizapi.io", "/api/v1/questions", queryParameters),
          headers: {
            "X-Api-Key": apiKey,
          });
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        List data = body;
        quizList =
            data.map<QuizModel>((json) => QuizModel.fromJson(json)).toList();
        amount = quizList.length;
        setState(() => isBusy = false);
        return quizList;
      } else {
        debugPrint('Error: ${response.statusCode}');
        setState(() => isBusy = false);
        return [];
      }
    } on Exception catch (e) {
      setState(() => isBusy = false);
      debugPrint('Error getQuiz: $e');
      return [];
    }
  }

  @override
  void initState() {
    getQuiz(widget.categories, widget.difficulty);
    super.initState();
  }

  @override
  void dispose() {
    questionNumber = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.width * .05;
    return isBusy
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : quizList.isEmpty
            ? notFound(width, height, quizState)
            : questionWidget();
  }

  Widget notFound(double width, double height, QuizState quizState) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text('No questions found!', style: TextStyle(fontSize: 20)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextButton(
                child: SizedBox(
                  width: width,
                  child: Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Go Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                onPressed: () => quizState.setStateBegin(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionWidget() {
    String question = quizList[questionNumber].question!;
    Answers answer = quizList[questionNumber].answers!;
    CorrectAnswers correctAnswer = quizList[questionNumber].correctAnswers!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Question №${questionNumber + 1}'),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              '${questionNumber + 1}/$amount',
              style: const TextStyle(fontSize: 18),
            ),
          )),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 0,
                thickness: 2,
              ),
            ],
          ),
          const SizedBox(height: 20),
          answerButton(
              checkAnswerA, answer.answerA, correctAnswer.answerACorrect),
          answerButton(
              checkAnswerB, answer.answerB, correctAnswer.answerBCorrect),
          answerButton(
              checkAnswerC, answer.answerC, correctAnswer.answerCCorrect),
          answerButton(
              checkAnswerD, answer.answerD, correctAnswer.answerDCorrect),
          answerButton(
              checkAnswerE, answer.answerE, correctAnswer.answerECorrect),
          answerButton(
              checkAnswerF, answer.answerF, correctAnswer.answerFCorrect),
        ],
      ),
    );
  }

  Widget answerButton(bool checkAnswer, String? answer, String? correctAnswer) {
    final quizState = Provider.of<QuizState>(context);
    return answer != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        answer,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                if (correctAnswer == "true") {
                  results.addAll({questionNumber + 1: 'Right'});
                } else {
                  results.addAll({questionNumber + 1: 'Wrong'});
                }
                if (questionNumber < amount - 1) {
                  setState(() => questionNumber++);
                } else {
                  quizState.setStateResult();
                }
              },
            ),
          )
        : Container();
  }
}
