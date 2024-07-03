import 'package:flutter/material.dart';

void checkAnswer({
  required BuildContext context,
  required String selectedOption,
  required String correctAnswer,
  required int answerCount,
  required VoidCallback nextQuestion,
}) {
  bool isCorrect = selectedOption == correctAnswer;
  if (isCorrect) {
    answerCount++;
  }
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isCorrect ? '정답!' : '오답'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Text(isCorrect ? '축하합니다! 정답입니다.' : '아쉽네요. 정답은 $correctAnswer입니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nextQuestion();
            },
            child: Text('다음문제'),
          ),
        ],
      );
    },
  );
}
