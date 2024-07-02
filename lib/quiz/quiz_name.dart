import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaist_week1/contact.dart';
import 'package:kaist_week1/contacts_provider.dart';
import 'package:kaist_week1/ranking_provider.dart';
import 'quiz_phonenumber.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      filteredContacts = contactsProvider.widget3GroupFilteredContacts.where((contact) => contact.image != 'assets/images/default.png').toList();
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
    for(int i=0;i<filteredContacts.length*4;i++){
      if(options.length>=3)
        break;
      String randomName = filteredContacts[random.nextInt(filteredContacts.length)].name;
      if (!options.contains(randomName)) {
        options.add(randomName);
      }
    }
    while (options.length < 3) {
      String randomName = contactsProvider.contacts[random.nextInt(contactsProvider.contacts.length)].name;
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
      barrierDismissible: false,
      builder: (context) {
        TextEditingController _name_nicknameController = TextEditingController();
        return AlertDialog(
          title: Text('모든 문제가 끝났습니다!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('맞춘 문제 개수: $answercount_name'),
              TextField(
                controller: _name_nicknameController,
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
                    _name_nicknameController.text,
                    answercount_name,
                    'name');
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
                  _generateNameQuizOptions();
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
            final rankings = rankingProvider.getRankings('name');

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
                      '이름 퀴즈 랭킹',
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
                        '아직 랭킹이 없습니다.\n 문제를 풀고 랭킹에 이름을 올려보세요!',
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
                                      entry.nickname, 'name');
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
    if (filteredContacts.isEmpty) {
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
          ),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRankingModal,
        child: Icon(Icons.leaderboard),
        tooltip: '이름 퀴즈 랭킹보기',
      ),
    );
  }

}
