import '../whoe_quiz_page.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contact.dart';
import '../contacts_provider.dart';
import '../ranking_provider.dart';
import 'quiz_phonenumber.dart';

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
      if (contactsProvider.widget3GroupFilteredContacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
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
      if (currentIndex < contactsProvider.widget3GroupFilteredContacts.length - 1) {
        currentIndex++;
        contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
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
        contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
        _generateBirthdayQuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController _birth_nicknameController = TextEditingController();
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('맞춘 문제 개수: $answercount_birth'),
              TextField(
                controller: _birth_nicknameController,
                decoration: InputDecoration(
                  labelText: '랭킹용 닉네임을 설정해주세요',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<RankingProvider>(context, listen: false).addRanking(
                    _birth_nicknameController.text,
                    answercount_birth,
                    'birthday');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('랭킹에 등록되었습니다'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // margin: EdgeInsets.symmetric(horizontal: 900.0, vertical: 0.0),
                    width: 200,
                  ),
                );
                setState(() {
                  currentIndex = 0;
                  contact =
                  Provider.of<ContactsProvider>(context, listen: false)
                      .contacts[currentIndex];
                  _generateBirthdayQuizOptions();
                });
              },
              child: Text('랭킹 등록'),
            ),
          ],
        );
      },
    );
  }
  void _showRankingModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<RankingProvider>(
          builder: (context, rankingProvider, child) {
            final rankings = rankingProvider.getRankings('birthday');

            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '생일 퀴즈 랭킹',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  rankings.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '아직 랭킹이 없습니다.\n문제를 풀고 랭킹에 이름을 올려보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  )
                      : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rankings.length,
                      itemBuilder: (context, index) {
                        final entry = rankings[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple[100],
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.nickname,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '점수: ${entry.score}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  // Implement logic to remove ranking entry
                                  rankingProvider.deleteRanking(
                                      entry.nickname, 'birthday');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
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
    if (contactsProvider.widget3GroupFilteredContacts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    if (options.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
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
                  Text('${currentIndex + 1}/${contactsProvider.widget3GroupFilteredContacts.length}'),
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
          ),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRankingModal,
        child: Icon(Icons.leaderboard),
        tooltip: '생일 퀴즈 랭킹보기',
      ),
    );
  }
}




