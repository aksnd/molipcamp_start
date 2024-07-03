import 'package:kaist_week1/whoe_quiz_page.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaist_week1/contact.dart';
import 'package:kaist_week1/contacts_provider.dart';
import 'package:kaist_week1/ranking_provider.dart';
import 'quiz_phonenumber.dart';
import 'package:kaist_week1/main.dart';
import 'package:kaist_week1/quiz/utils/calculator.dart';
import 'package:kaist_week1/quiz/utils/progress_bar.dart';
// import 'package:kaist_week1/quiz/utils/checkAnswer.dart';

//MBTI 퀴즈 - 탭2

class MBTIQuizPage extends StatefulWidget {
  @override
  _MBTIQuizPageState createState() => _MBTIQuizPageState();
}

class _MBTIQuizPageState extends State<MBTIQuizPage> {
  List<String> options = [];
  static const List<String> MBTI_LIST = ['INTJ','INTP','ENTJ','ENTP','INFJ','INFP','ENFJ','ENFP','ISTJ','ISFJ','ESTJ','ESFJ','ISTP','ISFP','ESTP','ESFP'];
  String correctAnswer = '';
  SimpleContact? contact;
  int currentIndex = 0;
  int answerCountMbti = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
      if (contactsProvider.widget3GroupFilteredContacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
          _generateMBTIQuizOptions();
        });
      }
      else{
        print('you die with empty');
      }
    });
  }

  void _generateMBTIQuizOptions() {
    if (contact == null) {

      return;
    }

    correctAnswer = contact!.mbti;
    options = [correctAnswer];

    Random random = Random();


    while (options.length < 4) {
      String randomMBTI = MBTI_LIST[random.nextInt(16)];
      if (!options.contains(randomMBTI)) {
        options.add(randomMBTI);
      }
    }
    print("you reached here!");
    options.shuffle();
  }

  void _checkAnswer(String selectedOption) {
    bool isCorrect = selectedOption == correctAnswer;
    if (isCorrect) {
      answerCountMbti++;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? '정답!' : '오답'),
          content: Text(isCorrect ? '축하합니다! 정답입니다.' : '아쉽네요. 정답은 $correctAnswer입니다.'),
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
        _generateMBTIQuizOptions();
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
        _generateMBTIQuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    double correctRate = calculateCorrectRate(answerCountMbti, currentIndex+1);


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController _mbti_nicknameController = TextEditingController();
        return SingleChildScrollView(
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('퀴즈를 끝내시겠어요?', style: TextStyle(fontSize: 20),),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('맞춘 문제 개수: $answerCountMbti/${currentIndex+1}'),
                Text('정답률: ${correctRate.toStringAsFixed(2)}%'),
                TextField(
                  controller: _mbti_nicknameController,
                  decoration: InputDecoration(
                    labelText: '랭킹용 닉네임을 설정해주세요',
                  ),
                ),
              ],
            ),
            actions: [

                 TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarWidget(initialIndex: 2),),
                      (route) => false,
                );
              },
              child: Text('나가기'),
            ),

              TextButton(
                onPressed: () {
                  Provider.of<RankingProvider>(context, listen: false).addRanking(
                      _mbti_nicknameController.text,
                      answerCountMbti, currentIndex+1,
                      'mbti');
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
                    answerCountMbti=0;
                    contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
                    _generateMBTIQuizOptions();
                  });
                },
                child: Text('랭킹 등록'),
              ),
            ],
          ),
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
            final rankings = rankingProvider.getRankings('mbti');

            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'mbti 퀴즈 랭킹',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8ECAE6),
                        ),
                      ),
                      Icon(Icons.auto_awesome, color: Color(0xFF8ECAE6),)
                    ],
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
                          color: Color(0xFF023047),
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
                                  Text('정답률: ${entry.correctRate.toStringAsFixed(2)}%'),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  // Implement logic to remove ranking entry
                                  rankingProvider.deleteRanking(
                                      entry.nickname, 'mbti');
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildProgressBar(context, currentIndex, contactsProvider.widget3GroupFilteredContacts.length),
            ),
            // Text('${currentIndex + 1}/${contactsProvider.widget3GroupFilteredContacts.length}'),

            Container(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: contact != null
                    ? _getImageProvider(contact!.image)
                    : SizedBox.shrink(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    contact != null ? "이름: ${contact!.name}" : "이름 없음",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "이 사람의 MBTI는?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 40.0, // 열 간의 간격을 설정합니다.
                        runSpacing: 10.0,
                        children: options
                            .map((option) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () => _checkAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8ECAE6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(option, style: TextStyle(color: Color(0xFF023047)),),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),




      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _showCompletionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3AB349),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.square, color: Colors.white, size: 15,),
                  SizedBox(width: 5,),
                  Text('퀴즈 끝내기', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            FloatingActionButton(
              onPressed: _showRankingModal,
              child: Icon(Icons.leaderboard),
              tooltip: 'mbti 퀴즈 랭킹보기',
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3AB349),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text('다음 문제', style: TextStyle(color: Colors.white)),
                  Icon(Icons.play_arrow, color: Colors.white, size: 20,),
                ],
              ),
            ),
          ],
        ),
      ),



    );
  }
}


