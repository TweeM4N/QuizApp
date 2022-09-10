import 'package:flutter/material.dart';

class QuizState extends ChangeNotifier {
  String quizState = 'begin';

  void setStateBegin() {
    quizState = 'begin';
    notifyListeners();
  }

  void setStateProcess() {
    quizState = 'process';
    notifyListeners();
  }

  void setStateResult() {
    quizState = 'result';
    notifyListeners();
  }
}
