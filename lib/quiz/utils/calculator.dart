
double calculateCorrectRate(int correctAnswers, int totalQuestions) {
  if (totalQuestions == 0) return 0;
  double rate = (correctAnswers / totalQuestions) * 100;
  return double.parse(rate.toStringAsFixed(2)); // 소수 둘째 자리까지 반올림
}


