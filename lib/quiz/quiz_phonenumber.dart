import '../whoe_quiz_page.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contact.dart';
import '../contacts_provider.dart';
import '../ranking_provider.dart';
import 'quiz_phonenumber.dart';
import 'package:kaist_week1/main.dart';
import 'package:kaist_week1/quiz/utils/calculator.dart';
import 'package:kaist_week1/quiz/utils/progress_bar.dart';
import 'package:kaist_week1/quiz/utils/checkAnswer.dart';


//전화번호 퀴즈 - 탭3
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
      if (contactsProvider.widget3GroupFilteredContacts.isNotEmpty) {
        setState(() {
          contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
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
    while (options.length < 4) {
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



  void _nextQuestion() {
    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    setState(() {
      if (currentIndex < contactsProvider.widget3GroupFilteredContacts.length - 1) {
        currentIndex++;
        contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
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
        contact = contactsProvider.widget3GroupFilteredContacts[currentIndex];
        _generate_phonenumber_QuizOptions();
      }
    });
  }

  void _showCompletionDialog() {
    final contactsProvider = Provider.of<ContactsProvider>(context, listen: false);
    double correctRate = calculateCorrectRate(answercount_phonenumber, currentIndex+1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController _phonenumber_nicknameController = TextEditingController();
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
                Text('맞춘 문제 개수: $answercount_phonenumber/${currentIndex+1}'),
                Text('정답률 : ${correctRate.toStringAsFixed(2)}%'),
                TextField(
                  controller: _phonenumber_nicknameController,
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
                  Provider.of<RankingProvider>(context, listen: false)
                      .addRanking(
                      _phonenumber_nicknameController.text,
                      answercount_phonenumber, currentIndex+1,
                      '전화번호');
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
                    answercount_phonenumber=0;
                    contact = Provider.of<ContactsProvider>(context, listen: false).widget3GroupFilteredContacts[currentIndex];
                    _generate_phonenumber_QuizOptions();
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
            final rankings = rankingProvider.getRankings('전화번호');

            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '전화번호 퀴즈 랭킹',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3AB349),
                        ),
                      ),
                      Icon(Icons.auto_awesome, color: Color(0xFF3AB349),)
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.nickname,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 8),
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
                                  rankingProvider.deleteRanking(entry.nickname,'전화번호');
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
              // Text('${currentIndex + 1}/${contactsProvider.widget3GroupFilteredContacts.length}'),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildProgressBar(context, currentIndex, contactsProvider.widget3GroupFilteredContacts.length),
              ),
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
                padding: const EdgeInsets.all(8.0),
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
                      "이 사람의 전화번호는?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10.0, // 열 간의 간격을 설정합니다.
                          runSpacing: 10.0,
                          children: options
                              .map((option) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                              onPressed: () => checkAnswer(context: context,
                                selectedOption: option,
                                correctAnswer: correctAnswer,
                                answerCount: answercount_phonenumber,
                                nextQuestion: _nextQuestion,),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8ECAE6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(option,  style: TextStyle(color: Color(0xFF023047)),),
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
              child: Text('퀴즈 끝내기', style: TextStyle(color: Colors.white)),
            ),
            FloatingActionButton(
              onPressed: _showRankingModal,
              child: Icon(Icons.leaderboard),
              tooltip: '전화번호 퀴즈 랭킹보기',
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3AB349),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('다음 문제', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

    );
  }
}

