import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Models/difficulty_model.dart';
import 'package:quizapp/Pages/question_page.dart';
import 'package:quizapp/Pages/result_page.dart';
import 'package:quizapp/Provider/quiz_state.dart';
import '../Models/categories_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Categories? _categories = Categories.linux;
  Difficulty? _difficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);
    final height = MediaQuery.of(context).size.width * .1;
    return (quizState.quizState == 'begin')
        ? startPage(quizState, height)
        : (quizState.quizState == 'process')
            ? QuestionPage(
                categories: _categories!,
                difficulty: _difficulty!,
              )
            : ResultPage(
                categories: _categories!,
                difficulty: _difficulty!,
              );
  }

  Widget startPage(QuizState quizState, double height) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              //Categories
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Category'),
                children: [
                  categotyListTile('Linux', Categories.linux),
                  categotyListTile('DevOps', Categories.devOps),
                  categotyListTile('Networking', Categories.networking),
                  categotyListTile('Programming', Categories.programming),
                  categotyListTile('Docker', Categories.docker),
                  categotyListTile('Kubernetes', Categories.kubernetes),
                ],
              ),
              //Difficulty
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Difficulty'),
                children: [
                  difficultyListTile('Easy', Difficulty.easy),
                  difficultyListTile('Medium', Difficulty.medium),
                  difficultyListTile('Hard', Difficulty.hard),
                ],
              ),
            ],
          ),
          //Start button
          startButton(quizState, height),
        ],
      ),
    );
  }

  Widget categotyListTile(String title, Categories value) {
    return RadioListTile<Categories>(
      title: Text(title),
      value: value,
      groupValue: _categories,
      onChanged: (Categories? value) {
        setState(() {
          _categories = value;
        });
      },
    );
  }

  Widget difficultyListTile(String title, Difficulty value) {
    return RadioListTile<Difficulty>(
      title: Text(title),
      value: value,
      groupValue: _difficulty,
      onChanged: (Difficulty? value) {
        setState(() {
          _difficulty = value;
        });
      },
    );
  }

  Widget startButton(QuizState quizState, double height) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        child: Card(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          margin: EdgeInsets.only(bottom: height),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Start',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap: () => quizState.setStateProcess(),
      ),
    );
  }
}
