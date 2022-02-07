class Question {
  late String questionText;
  late String optionA;
  late String optionB;
  late String optionC;
  late String answer;

  Question(
    this.questionText,
    this.optionA,
    this.optionB,
    this.optionC,
    this.answer,
  );
  factory Question.fromMap(Map data) {
    return Question(
      data['question'] ?? '',
      data['option_a'] ?? '',
      data['option_b'] ?? '',
      data['option_c'] ?? '',
      data['answer'] ?? ' ',
    );
  }
}
