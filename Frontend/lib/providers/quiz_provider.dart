import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizProvider with ChangeNotifier {
  final List<QuizQuestion> _questions = QuizQuestion.getSampleQuestions();
  int _currentQuestionIndex = 0;
  int? _selectedOption;
  int _score = 100;
  bool _hasAnswered = false;
  bool _showResult = false;

  List<QuizQuestion> get questions => _questions;
  QuizQuestion get currentQuestion => _questions[_currentQuestionIndex];
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedOption => _selectedOption;
  int get score => _score;
  bool get hasAnswered => _hasAnswered;
  bool get showResult => _showResult;
  bool get canSubmit => _selectedOption != null && !_hasAnswered;

  void selectOption(int optionIndex) {
    if (!_hasAnswered) {
      _selectedOption = optionIndex;
      notifyListeners();
    }
  }

  void submitAnswer() {
    if (_selectedOption != null && !_hasAnswered) {
      _hasAnswered = true;
      _showResult = true;
      
      // Check if answer is correct
      if (_selectedOption == currentQuestion.correctAnswer) {
        // Keep current score for correct answer
      } else {
        // Deduct points for wrong answer (optional)
        _score = (_score - 20).clamp(0, 100);
      }
      
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _resetQuestionState();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 100;
    _resetQuestionState();
  }

  void _resetQuestionState() {
    _selectedOption = null;
    _hasAnswered = false;
    _showResult = false;
    notifyListeners();
  }

  bool isCorrectAnswer(int optionIndex) {
    return optionIndex == currentQuestion.correctAnswer;
  }

  bool isWrongAnswer(int optionIndex) {
    return _hasAnswered && 
           _selectedOption == optionIndex && 
           optionIndex != currentQuestion.correctAnswer;
  }
}