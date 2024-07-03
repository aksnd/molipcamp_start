// utils/progress_bar.dart
import 'package:flutter/material.dart';
import 'package:kaist_week1/quiz/quiz_phonenumber.dart';
import 'package:kaist_week1/quiz/quiz_mbti.dart';


Widget buildProgressBar(BuildContext context, int currentIndex, int totalCount) {
  double progress = (currentIndex + 1) / totalCount;
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      Container(
        width: progress * MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Color(0xFF3AB349),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      Positioned.fill(
        child: Center(
          child: Text(
            '${currentIndex + 1}/${totalCount}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
