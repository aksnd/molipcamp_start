import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './contact.dart';
import 'contacts_provider.dart';

class free_page extends StatelessWidget {
  const free_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<String> options;
  late String correctAnswer;
  late Contact contact;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      if (contactsProvider.contacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.contacts[currentIndex];
          _generateQuizOptions();
        });
      }
    });
  }

  void _generateQuizOptions() {
    correctAnswer = contact.phone;
    options = [correctAnswer];

    Random random = Random();
    while (options.length < 3) {
      String randomPhone = "010-" +
          (random.nextInt(9000) + 1000).toString() +
          "-" +
          (random.nextInt(9000) + 1000).toString();
      if (!options.contains(randomPhone)) {
        options.add(randomPhone);
      }
    }

    options.shuffle();
  }

  void _checkAnswer(String selectedOption) {
    bool isCorrect = selectedOption == correctAnswer;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? '정답!' : '오답'),
          content: Text(
              isCorrect ? '축하합니다! 정답입니다.' : '아쉽네요. 정답은 ${correctAnswer}입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    setState(() {
      if (currentIndex < contactsProvider.contacts.length - 1) {
        currentIndex++;
        contact = contactsProvider.contacts[currentIndex];
        _generateQuizOptions();
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _previousQuestion() {
    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        contact = contactsProvider.contacts[currentIndex];
        _generateQuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Text('모든 문제를 완료하셨습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Image _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.file(File(imageUrl), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);
    if (contactsProvider.contacts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _previousQuestion,
                child: Text('이전 문제'),
              ),
              Text('${currentIndex + 1}/${contactsProvider.contacts.length}'),
              TextButton(
                onPressed: _nextQuestion,
                child: Text('다음 문제'),
              ),
            ],
          ),
          Container(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _getImageProvider(contact.image),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "이름 ${contact.name}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "이 사람의 전화번호는?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                ...options.map((option) => ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  child: Text(option),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
