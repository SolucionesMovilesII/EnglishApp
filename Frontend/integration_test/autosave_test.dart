import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:english_app/main.dart' as app;
import 'package:english_app/providers/progress_provider.dart';


import 'package:provider/provider.dart';
import 'test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('QA: Autosave Functionality Tests', () {
    testWidgets('QA-AS-001: Autosave in vocabulary module', (WidgetTester tester) async {
      print('🧪 QA-AS-001: Testing autosave in vocabulary...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Login
      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Navigate to vocabulary
      await _navigateToVocabulary(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Monitor initial state
      final initialSaveState = progressProvider.progressState;
      print('  • Initial state: $initialSaveState');

      // Simulate word learning with intervals
      for (int i = 0; i < 5; i++) {
        print('  • Learning word ${i + 1}...');
        
        // Mark word as learned
        await _learnWord(tester, i);
        await tester.pump(Duration(milliseconds: 500));
        
        // Verify that autosave is triggered
        await tester.pump(Duration(seconds: 2));
        
        expect(progressProvider.progressState, anyOf([ProgressState.saving, ProgressState.saved]),
          reason: 'Autosave should trigger after learning a word');
        
        print('    ✓ Autosave activated - State: ${progressProvider.progressState}');
      }
      
      // Verify that final progress was saved
      await tester.pump(Duration(seconds: 3));
      expect(progressProvider.progressState, ProgressState.saved,
        reason: 'Final progress should be saved');
      
      print('✅ QA-AS-001: Vocabulary autosave successful');
    });

    testWidgets('QA-AS-002: Autosave in quiz module', (WidgetTester tester) async {
      print('🧪 QA-AS-002: Testing autosave in quiz...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Navigate to quiz
      await _navigateToQuiz(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Answer quiz questions
      for (int i = 0; i < 3; i++) {
        print('  • Answering question ${i + 1}...');
        
        await _answerQuizQuestion(tester, i, 0); // Answer first option
        await tester.pump(Duration(milliseconds: 500));
        
        // Verify autosave after each answer
        await tester.pump(Duration(seconds: 2));
        
        expect(progressProvider.progressState, anyOf([ProgressState.saving, ProgressState.saved]),
          reason: 'Autosave should activate after answering each question');
        
        print('    ✓ Progress saved - Question ${i + 1}');
      }
      
      print('✅ QA-AS-002: Quiz autosave successful');
    });

    testWidgets('QA-AS-003: Autosave in reading module', (WidgetTester tester) async {
      print('🧪 QA-AS-003: Testing autosave in reading...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Navigate to reading
      await _navigateToReading(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Simulate reading progress
      for (int i = 0; i < 4; i++) {
        print('  • Advancing to paragraph ${i + 1}...');
        
        await _advanceReading(tester);
        await tester.pump(Duration(milliseconds: 500));
        
        // Verify autosave
        await tester.pump(Duration(seconds: 2));
        
        expect(progressProvider.progressState, anyOf([ProgressState.saving, ProgressState.saved]),
          reason: 'Autosave should activate when advancing in reading');
        
        print('    ✓ Reading progress saved');
      }
      
      print('✅ QA-AS-003: Reading autosave successful');
    });

    testWidgets('QA-AS-004: Autosave in interview module', (WidgetTester tester) async {
      print('🧪 QA-AS-004: Testing autosave in interviews...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Navigate to interviews
      await _navigateToInterview(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Simulate interview responses
      for (int i = 0; i < 3; i++) {
        print('  • Answering interview question ${i + 1}...');
        
        await _answerInterviewQuestion(tester, i);
        await tester.pump(Duration(milliseconds: 500));
        
        // Verify autosave
        await tester.pump(Duration(seconds: 2));
        
        expect(progressProvider.progressState, anyOf([ProgressState.saving, ProgressState.saved]),
          reason: 'Autosave should activate after answering in interviews');
        
        print('    ✓ Interview response saved');
      }
      
      print('✅ QA-AS-004: Interview autosave successful');
    });

    testWidgets('QA-AS-005: Autosave error handling', (WidgetTester tester) async {
      print('🧪 QA-AS-005: Testing autosave error handling...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Simulate network error
      await _simulateNetworkError(tester);
      
      // Attempt to make progress during error
      await _navigateToVocabulary(tester);
      await _learnWord(tester, 0);
      
      // Wait for retries to complete (ProgressProvider has 3 retry attempts with delays)
      await tester.pump(Duration(seconds: 8));
      
      // Verify that the system handles the error correctly
      expect(progressProvider.progressState, anyOf([ProgressState.error, ProgressState.retrying]),
        reason: 'System should handle network errors correctly');
      
      // Verify that there is pending progress
      expect(progressProvider.hasPendingProgress, true,
        reason: 'There should be pending progress when save fails');
      
      // Simulate network recovery
      await _simulateNetworkRecovery(tester);
      await tester.pump(Duration(seconds: 3));
      
      // Verify that progress synchronizes
      expect(progressProvider.progressState, ProgressState.saved,
        reason: 'Progress should synchronize after recovering connection');
      
      print('✅ QA-AS-005: Autosave error handling successful');
    });

    testWidgets('QA-AS-006: Autosave concurrency', (WidgetTester tester) async {
      print('🧪 QA-AS-006: Testing autosave concurrency...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Enable test mode for the provider
      progressProvider.enableTestMode();
      
      // Simulate rapid activity across multiple modules
      print('  • Rapid activity in vocabulary...');
      await _navigateToVocabulary(tester);
      await _learnWord(tester, 0);
      
      print('  • Quick switch to quiz...');
      await _navigateToQuiz(tester);
      await _answerQuizQuestion(tester, 0, 1);
      
      print('  • Quick switch to reading...');
      await _navigateToReading(tester);
      await _advanceReading(tester);
      
      // Wait for all autosaves to process
      await tester.pump(Duration(seconds: 4));
      
      // Verify that the system handled concurrency correctly
      expect(progressProvider.progressState, ProgressState.saved,
        reason: 'System should handle multiple concurrent autosaves');
      
      expect(progressProvider.hasPendingProgress, false,
        reason: 'There should be no pending progress after synchronization');
      
      print('✅ QA-AS-006: Autosave concurrency handled correctly');
    });
  });
}

// Helper methods
Future<void> _performLogin(WidgetTester tester) async {
  final emailField = find.byKey(Key('email_field'));
  final passwordField = find.byKey(Key('password_field'));
  final loginButton = find.byKey(Key('login_button'));

  if (emailField.evaluate().isNotEmpty) {
    await tester.enterText(emailField, TestConfig.validEmail);
    await tester.enterText(passwordField, TestConfig.validPassword);
    await tester.tap(loginButton);
    await tester.pumpAndSettle(Duration(seconds: 2));
  }
}

Future<void> _navigateToVocabulary(WidgetTester tester) async {
  final vocabButton = find.byKey(Key('vocabulary_module'));
  if (vocabButton.evaluate().isNotEmpty) {
    await tester.tap(vocabButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _navigateToQuiz(WidgetTester tester) async {
  final quizButton = find.byKey(Key('quiz_module'));
  if (quizButton.evaluate().isNotEmpty) {
    await tester.tap(quizButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _navigateToReading(WidgetTester tester) async {
  final readingButton = find.byKey(Key('reading_module'));
  if (readingButton.evaluate().isNotEmpty) {
    await tester.tap(readingButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _navigateToInterview(WidgetTester tester) async {
  final interviewButton = find.byKey(Key('interview_module'));
  if (interviewButton.evaluate().isNotEmpty) {
    await tester.tap(interviewButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _learnWord(WidgetTester tester, int wordIndex) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  
  // Simulate learning a word by calling the progress provider directly
  await progressProvider.onVocabularyPracticed(
    'vocabulary_chapter_1', 
    'word_$wordIndex', 
    wordIndex + 1
  );
  
  // Also try to tap the UI button if it exists
  final learnButton = find.byKey(Key('learn_word_$wordIndex'));
  if (learnButton.evaluate().isEmpty) {
    final genericButton = find.byKey(Key('learn_word_button'));
    if (genericButton.evaluate().isNotEmpty) {
      await tester.tap(genericButton);
    }
  } else {
    await tester.tap(learnButton);
  }
}

Future<void> _answerQuizQuestion(WidgetTester tester, int questionIndex, int answerIndex) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  
  // Simulate answering a quiz question by calling the progress provider directly
  await progressProvider.onQuizAnswered(
    'quiz_chapter_1',
    (questionIndex + 1) * 20.0, // Score based on question number
    questionIndex
  );
  
  // Also try to tap the UI button if it exists
  final answerButton = find.byKey(Key('quiz_answer_$answerIndex'));
  if (answerButton.evaluate().isNotEmpty) {
    await tester.tap(answerButton);
  }
}

Future<void> _advanceReading(WidgetTester tester) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  
  // Simulate reading progress by calling the progress provider directly
  await progressProvider.onReadingProgress(
    'reading_chapter_1',
    DateTime.now().millisecond % 5 + 1, // Random paragraph number
    false
  );
  
  // Also try to tap the UI button if it exists
  final nextButton = find.byKey(Key('next_paragraph'));
  if (nextButton.evaluate().isNotEmpty) {
    await tester.tap(nextButton);
  }
}

Future<void> _answerInterviewQuestion(WidgetTester tester, int questionIndex) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  
  // Simulate answering an interview question by calling the progress provider directly
  await progressProvider.onInterviewAnswer(
    'interview_chapter_1',
    questionIndex,
    'Test answer for question $questionIndex'
  );
  
  // Also try to interact with UI if it exists
  final answerField = find.byKey(Key('interview_answer_field'));
  final submitButton = find.byKey(Key('submit_interview_answer'));
  
  if (answerField.evaluate().isNotEmpty && submitButton.evaluate().isNotEmpty) {
    await tester.enterText(answerField, 'Test answer for question $questionIndex');
    await tester.tap(submitButton);
  }
}

Future<void> _simulateNetworkError(WidgetTester tester) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  progressProvider.simulateNetworkError(true);
}

Future<void> _simulateNetworkRecovery(WidgetTester tester) async {
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  progressProvider.simulateNetworkError(false);
}