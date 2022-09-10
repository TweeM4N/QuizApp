class QuizModel {
  int? id;
  String? question;
  String? description;
  Answers? answers;
  String? multipleCorrectAnswers;
  CorrectAnswers? correctAnswers;
  String? explanation;
  String? tip;
  List<Tags>? tags;
  String? category;
  String? difficulty;

  QuizModel(
      {this.id,
      this.question,
      this.description,
      this.answers,
      this.multipleCorrectAnswers,
      this.correctAnswers,
      this.explanation,
      this.tip,
      this.tags,
      this.category,
      this.difficulty});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final question = json['question'];
    final description = json['description'];
    final answers = Answers.fromJson(json['answers']);
    final multipleCorrectAnswers = json['multiple_correct_answers'];
    final correctAnswers = CorrectAnswers.fromJson(json['correct_answers']);
    final explanation = json['explanation'];
    final tip = json['tip'];
    final tagsData = json['tags'] as List<dynamic>?;
    final tags = tagsData != null
        ? tagsData.map((tagsData) => Tags.fromJson(tagsData)).toList()
        : <Tags>[];
    final category = json['category'];
    final difficulty = json['difficulty'];
    return QuizModel(
      id: id,
      question: question,
      description: description,
      answers: answers,
      multipleCorrectAnswers: multipleCorrectAnswers,
      correctAnswers: correctAnswers,
      explanation: explanation,
      tags: tags,
      tip: tip,
      category: category,
      difficulty: difficulty,
    );
  }
}

class Answers {
  String? answerA;
  String? answerB;
  String? answerC;
  String? answerD;
  String? answerE;
  String? answerF;

  Answers(
      {this.answerA,
      this.answerB,
      this.answerC,
      this.answerD,
      this.answerE,
      this.answerF});

  factory Answers.fromJson(Map<String, dynamic> json) {
    final answerA = json['answer_a'];
    final answerB = json['answer_b'];
    final answerC = json['answer_c'];
    final answerD = json['answer_d'];
    final answerE = json['answer_e'];
    final answerF = json['answer_f'];
    return Answers(
      answerA: answerA,
      answerB: answerB,
      answerC: answerC,
      answerD: answerD,
      answerE: answerE,
      answerF: answerF,
    );
  }
}

class CorrectAnswers {
  String? answerACorrect;
  String? answerBCorrect;
  String? answerCCorrect;
  String? answerDCorrect;
  String? answerECorrect;
  String? answerFCorrect;

  CorrectAnswers(
      {this.answerACorrect,
      this.answerBCorrect,
      this.answerCCorrect,
      this.answerDCorrect,
      this.answerECorrect,
      this.answerFCorrect});

  factory CorrectAnswers.fromJson(Map<String, dynamic> json) {
    final answerACorrect = json['answer_a_correct'];
    final answerBCorrect = json['answer_b_correct'];
    final answerCCorrect = json['answer_c_correct'];
    final answerDCorrect = json['answer_d_correct'];
    final answerECorrect = json['answer_e_correct'];
    final answerFCorrect = json['answer_f_correct'];
    return CorrectAnswers(
      answerACorrect: answerACorrect,
      answerBCorrect: answerBCorrect,
      answerCCorrect: answerCCorrect,
      answerDCorrect: answerDCorrect,
      answerECorrect: answerECorrect,
      answerFCorrect: answerFCorrect,
    );
  }
}

class Tags {
  String? name;

  Tags({this.name});

  factory Tags.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    return Tags(name: name);
  }
}
