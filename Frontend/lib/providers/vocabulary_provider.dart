import 'package:flutter/material.dart';
import 'progress_provider.dart';

class VocabularyWord {
  final String word;
  final String meaning;
  final String pronunciation;
  final List<String> examples;
  
  VocabularyWord({
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.examples,
  });
}

class VocabularyProvider with ChangeNotifier {
  final ProgressProvider? _progressProvider;
  final String _chapterId;
  
  final List<VocabularyWord> _words = [
    VocabularyWord(
      word: 'Apple',
      meaning: 'A round fruit with red or green skin',
      pronunciation: '/ˈæpəl/',
      examples: ['I ate an apple for breakfast', 'The apple tree is blooming'],
    ),
    VocabularyWord(
      word: 'Book',
      meaning: 'A written or printed work consisting of pages',
      pronunciation: '/bʊk/',
      examples: ['I am reading a good book', 'She bought a new book'],
    ),
    VocabularyWord(
      word: 'House',
      meaning: 'A building for human habitation',
      pronunciation: '/haʊs/',
      examples: ['We live in a big house', 'The house has a garden'],
    ),
  ];
  
  int _currentWordIndex = 0;
  int _wordsLearned = 0;
  bool _isStudyMode = true;
  
  VocabularyProvider({
    ProgressProvider? progressProvider,
    String chapterId = 'vocab-chapter-1',
  }) : _progressProvider = progressProvider,
       _chapterId = chapterId;
  
  // Getters
  List<VocabularyWord> get words => _words;
  VocabularyWord get currentWord => _words[_currentWordIndex];
  int get currentWordIndex => _currentWordIndex;
  int get wordsLearned => _wordsLearned;
  bool get isStudyMode => _isStudyMode;
  bool get isLastWord => _currentWordIndex >= _words.length - 1;
  double get progress => _words.isEmpty ? 0.0 : (_currentWordIndex + 1) / _words.length;
  
  // Actions
  void nextWord() {
    if (_currentWordIndex < _words.length - 1) {
      _currentWordIndex++;
      
      // Auto-save progress when moving to next word
      _progressProvider?.onVocabularyPracticed(
        _chapterId,
        currentWord.word,
        _wordsLearned,
      );
      
      notifyListeners();
    }
  }
  
  void previousWord() {
    if (_currentWordIndex > 0) {
      _currentWordIndex--;
      notifyListeners();
    }
  }
  
  void markWordAsLearned() {
    if (_wordsLearned < _words.length) {
      _wordsLearned++;
      
      // Auto-save progress when marking word as learned
      _progressProvider?.onVocabularyPracticed(
        _chapterId,
        currentWord.word,
        _wordsLearned,
      );
      
      notifyListeners();
      
      // If all words are learned, complete the chapter
      if (_wordsLearned >= _words.length) {
        _progressProvider?.onChapterCompleted(_chapterId, 100.0);
      }
    }
  }
  
  void toggleStudyMode() {
    _isStudyMode = !_isStudyMode;
    notifyListeners();
  }
  
  void goToWord(int index) {
    if (index >= 0 && index < _words.length) {
      _currentWordIndex = index;
      
      // Auto-save progress when jumping to specific word
      _progressProvider?.onVocabularyPracticed(
        _chapterId,
        currentWord.word,
        _wordsLearned,
      );
      
      notifyListeners();
    }
  }
  
  void resetProgress() {
    _currentWordIndex = 0;
    _wordsLearned = 0;
    _isStudyMode = true;
    notifyListeners();
  }
  
  // Get words that haven't been learned yet
  List<VocabularyWord> get unlearnedWords {
    if (_wordsLearned >= _words.length) return [];
    return _words.skip(_wordsLearned).toList();
  }
  
  // Get percentage of completion
  double get completionPercentage {
    if (_words.isEmpty) return 0.0;
    return (_wordsLearned / _words.length) * 100;
  }
}