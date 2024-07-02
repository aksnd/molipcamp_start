import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './contact.dart';
import 'contacts_provider.dart';
import 'ranking_provider.dart';
import 'quiz/quiz_phonenumber.dart';
import 'quiz/quiz_name.dart';
import 'quiz/quiz_birthday.dart';
import 'quiz/quiz_mbti.dart';


//이게 전체 총괄
class free_page extends StatelessWidget {
  final String selectedGroup;

  const free_page({super.key, required this.selectedGroup});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('퀴즈'),
          backgroundColor: Colors.pinkAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: '이름 퀴즈'),
              Tab(text: 'MBTI'),
              Tab(text: '전화번호'),
              Tab(text: '생일 퀴즈'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            NameQuizPage(),
            MBTIQuizPage(),
            PhoneNumberQuizPage(),
            BirthdayQuizPage(),
          ],
        ),
      ),
    );
  }
}









