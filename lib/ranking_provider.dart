import 'package:flutter/material.dart';

class RankingEntry {
  final String nickname;
  final String category;
  final int score;

  RankingEntry(this.nickname, this.score, this.category);
}

class RankingProvider with ChangeNotifier {
  Map<String, List<RankingEntry>> _rankings = {
    'name': [],
    'mbti': [],
    'phone': [],
    'birthday': [],
  };

  List<RankingEntry> getRankings(String category) {
    if (_rankings.containsKey(category)) {
      return List.unmodifiable(_rankings[category]!);

    } else {
      print('그런 카테고리는 없음');
      return [];
    }
  }

  void addRanking(String nickname, int score, String category) {

    if (_rankings[category] == null) {
      _rankings[category] = [];
    }
    _rankings[category]!.add(RankingEntry(nickname, score, category));
    _rankings[category]!.sort((a, b) => b.score.compareTo(a.score));
    notifyListeners();
  }

  void clearRankings(String category) {
    _rankings[category]!.clear();
    notifyListeners();
  }
  void deleteRanking(String nickname, String category) {
    if (_rankings.containsKey(category)) {
      _rankings[category]!.removeWhere((entry) => entry.nickname == nickname);
      notifyListeners();
    }
  }
}
