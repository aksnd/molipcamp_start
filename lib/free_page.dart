import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './contact.dart';
import 'contacts_provider.dart';


//이게 전체 총괄
class free_page extends StatelessWidget {
  const free_page({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('퀴즈'),
          backgroundColor: Colors.pinkAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: '이름 퀴즈'),
              Tab(text: '전화번호 퀴즈'),
              Tab(text: '생일 퀴즈'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NameQuizPage(),
            PhoneNumberQuizPage(),
            BirthdayQuizPage(),
          ],
        ),
      ),
    );
  }
}


//전화번호 퀴즈 - 탭2
class PhoneNumberQuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<PhoneNumberQuizPage> {
  List<String> options=[];
  String correctAnswer='';
  SimpleContact? contact;
  int currentIndex = 0;
  int answercount_phonenumber = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      if (contactsProvider.contacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.contacts[currentIndex];
          _generate_phonenumber_QuizOptions();
        });
      }
    });
  }

  void _generate_phonenumber_QuizOptions() {

    if (contact == null)
      {print("contact = null");
      return;}

    correctAnswer = contact!.phone;
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
    if (isCorrect) {
      answercount_phonenumber++;
    }

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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextQuestion();
              },
              child: Text('다음문제'),
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
        _generate_phonenumber_QuizOptions();
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
        _generate_phonenumber_QuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Text('맞춘 문제 개수: $answercount_phonenumber'),
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
    if (options.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
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
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: contact != null ? _getImageProvider(contact!.image) : SizedBox.shrink(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact != null ? "이름: ${contact!.name}" : "이름 없음",
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


//이름 퀴즈 - 탭1

class NameQuizPage extends StatefulWidget {
  @override
  _NameQuizPageState createState() => _NameQuizPageState();
}

class _NameQuizPageState extends State<NameQuizPage> {
  List<String> options = [];
  String correctAnswer = '';
  SimpleContact? contact;
  int currentIndex = 0;
  int answercount_name = 0;
  List<SimpleContact> filteredContacts = [];

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
  //     if (contactsProvider.contacts.isNotEmpty) {
  //       setState(() {
  //         contact = contactsProvider.contacts[currentIndex];
  //         _generateNameQuizOptions();
  //       });
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      filteredContacts = contactsProvider.contacts.where((contact) => contact.image != 'assets/images/default.png').toList();
      if (filteredContacts.isNotEmpty) {
        setState(() {
          contact = filteredContacts[currentIndex];
          _generateNameQuizOptions();
        });
      }
    });
  }

  void _generateNameQuizOptions() {
    if (contact == null) {
      print("contact = null");
      return;
    }

    correctAnswer = contact!.name;
    options = [correctAnswer];

    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    Random random = Random();
    while (options.length < 3) {
      // String randomName = contactsProvider.contacts[random.nextInt(contactsProvider.contacts.length)].name;
      String randomName = filteredContacts[random.nextInt(filteredContacts.length)].name;
      if (!options.contains(randomName)) {
        options.add(randomName);
      }
    }

    options.shuffle();
  }

  void _checkAnswer(String selectedOption) {
    bool isCorrect = selectedOption == correctAnswer;
    if (isCorrect) {
      answercount_name++;
    }

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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextQuestion();
              },
              child: Text('다음문제'),
            ),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    // final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    // setState(() {
    //   if (currentIndex < contactsProvider.contacts.length - 1) {
    //     currentIndex++;
    //     contact = contactsProvider.contacts[currentIndex];
    //     _generateNameQuizOptions();
    //   }
    setState(() {
      if (currentIndex < filteredContacts.length - 1) {
        currentIndex++;
        contact = filteredContacts[currentIndex];
        _generateNameQuizOptions();
      }
    else {
        _showCompletionDialog();
      }
    });
  }

  void _previousQuestion() {
    // final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    // setState(() {
    //   if (currentIndex > 0) {
    //     currentIndex--;
    //     contact = contactsProvider.contacts[currentIndex];
    //     _generateNameQuizOptions();
    //   }
    // });
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        contact = filteredContacts[currentIndex];
        _generateNameQuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Text('맞춘 문제 개수: $answercount_name'),
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
    if (filteredContacts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    if (options.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
  // @override
  // Widget build(BuildContext context) {
  //   final contactsProvider = Provider.of<ContactsProvider>(context);
  //   if (contactsProvider.contacts.isEmpty) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //   if (options.isEmpty) {
  //     return Center(child: CircularProgressIndicator());
  //   }

    return Padding(
      padding: const EdgeInsets.all(0.0),
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
              Text('${currentIndex + 1}/${filteredContacts.length}'),
              TextButton(
                onPressed: _nextQuestion,
                child: Text('다음 문제'),
              ),
            ],
          ),
          Container(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: contact != null ? _getImageProvider(contact!.image) : SizedBox.shrink(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 8),
                Text(
                  "이 사람의 이름은?",
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



//생일 퀴즈 - 탭3
class BirthdayQuizPage extends StatefulWidget {
  @override
  _BirthdayQuizPageState createState() => _BirthdayQuizPageState();
}

class _BirthdayQuizPageState extends State<BirthdayQuizPage> {
  List<String> options = [];
  String correctAnswer = '';
  SimpleContact? contact;
  int currentIndex = 0;
  int answercount_birth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      if (contactsProvider.contacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.contacts[currentIndex];
          _generateBirthdayQuizOptions();
        });
      }
    });
  }

  void _generateBirthdayQuizOptions() {
    if (contact == null) {
      print("contact = null");
      return;
    }

    correctAnswer = contact!.birthday;
    options = [correctAnswer];

    Random random = Random();
    while (options.length < 3) {
      String randomBirthday = "${random.nextInt(8) + 1998}".padLeft(2, '0') +
          "." +
          "${random.nextInt(12) + 1}".padLeft(2, '0') +
          "." +
          "${random.nextInt(30) + 1}";
      if (!options.contains(randomBirthday)) {
        options.add(randomBirthday);
      }
    }

    options.shuffle();
  }

  void _checkAnswer(String selectedOption) {
    bool isCorrect = selectedOption == correctAnswer;
    if (isCorrect) {
      answercount_birth++;
    }

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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextQuestion();
              },
              child: Text('다음문제'),
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
        _generateBirthdayQuizOptions();
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
        _generateBirthdayQuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Text('맞춘 문제 개수: $answercount_birth'),
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
    if (options.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
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
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: contact != null ? _getImageProvider(contact!.image) : SizedBox.shrink(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact != null ? "이름: ${contact!.name}" : "이름 없음",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "이 사람의 생일은?",
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


