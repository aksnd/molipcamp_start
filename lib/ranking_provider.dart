import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RankingEntry {
  final String nickname;
  final String category;
  final int score;

  RankingEntry(this.nickname, this.score, this.category);

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'score': score,
      'category': category,
    };
  }

  factory RankingEntry.fromMap(Map<String, dynamic> map) {
    return RankingEntry(
      map['nickname'],
      map['score'],
      map['category'],
    );
  }
}

class RankingProvider with ChangeNotifier {
  Map<String, List<RankingEntry>> _rankings = {
    'name': [],
    'mbti': [],
    'phone': [],
    'birthday': [],
  };
  static const String _rankingsKey = 'rankings';

  RankingProvider() {
    // 앱 시작 시 저장된 랭킹 데이터를 불러옴
    _loadRankingsFromPrefs();
  }
  List<RankingEntry> getRankings(String category) {
    if (_rankings.containsKey(category)) {
      return List.unmodifiable(_rankings[category]!);

    } else {
      return [];
    }
  }

  void addRanking(String nickname, int score, String category) {

    if (_rankings[category] == null) {
      _rankings[category] = [];
    }
    _rankings[category]!.add(RankingEntry(nickname, score, category));
    _rankings[category]!.sort((a, b) => b.score.compareTo(a.score));
    _saveRankingsToPrefs(); // 변경 사항을 저장
    notifyListeners();
  }

  void clearRankings(String category) {
    _rankings[category]!.clear();
    _saveRankingsToPrefs(); // 변경 사항을 저장
    notifyListeners();
  }
  void deleteRanking(String nickname, String category) {
    if (_rankings.containsKey(category)) {
      _rankings[category]!.removeWhere((entry) => entry.nickname == nickname);
      _saveRankingsToPrefs(); // 변경 사항을 저장
      notifyListeners();
    }
  }
  //여기서부턴 shared prefernce 관련 함수 (껐다 켜도 데이터 로드)
  Future<void> _loadRankingsFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_rankingsKey)) {
        String jsonStr = prefs.getString(_rankingsKey)!;
        Map<String, dynamic> map = jsonDecode(jsonStr);
        _rankings = map.map((key, value) => MapEntry(key, (value as List<dynamic>).map((e) => RankingEntry.fromMap(e)).toList()));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading rankings: $e');
      // Handle error as needed
    }
  }
  Future<void> _saveRankingsToPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> map = _rankings.map((key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()));
      String jsonStr = jsonEncode(map);
      await prefs.setString(_rankingsKey, jsonStr);
    } catch (e) {
      print('Error saving rankings: $e');
      // Handle error as needed
    }
  }
}
