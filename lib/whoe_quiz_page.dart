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

  const free_page({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('퀴즈 풀이', style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFF3AB349),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            tabs: [
              Tab(text: '이름'),
              Tab(text: 'MBTI'),
              Tab(text: '전화번호'),
              Tab(text: '생일'),
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









