import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_app/main.dart' as app;
import 'package:english_app/providers/auth_provider.dart';
import 'package:english_app/providers/progress_provider.dart';
import 'package:english_app/providers/vocabulary_provider.dart';

import 'package:provider/provider.dart';
import 'test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('QA: Session Resumption and Autosave Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      // Clear SharedPreferences before tests
      prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    tearDownAll(() async {
      // Clean up after tests
      await prefs.clear();
    });

    testWidgets('QA-001: Session resumption after complete closure', (WidgetTester tester) async {
      print('🧪 QA-001: Testing session resumption...');
      
      // Initialize the app
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 1: User login
      await _performLogin(tester);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Step 2: Navigate to vocabulary and make progress
      await _navigateToVocabulary(tester);
      await tester.pumpAndSettle(Duration(seconds: 1));
      
      // Simulate vocabulary progress
      await _makeVocabularyProgress(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 3: Verify that progress was automatically saved
      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      expect(progressProvider.progressState, ProgressState.saved, 
        reason: 'Progress should have been saved automatically');

      // Step 4: Simulate complete app closure (restart providers)
      await _simulateAppRestart(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 5: Verify that session resumes automatically
      final authProvider = Provider.of<AuthProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(authProvider.authState, AuthState.authenticated, 
        reason: 'Session should resume automatically');

      // Step 6: Verify that progress is maintained
      await _verifyProgressPersistence(tester);
      
      print('✅ QA-001: Session resumption successful');
    });

    testWidgets('QA-002: Automatic autosave every few seconds', (WidgetTester tester) async {
      print('🧪 QA-002: Testing automatic autosave...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Navigate to quiz
      await _navigateToQuiz(tester);
      await tester.pumpAndSettle();

      // Monitor progress state during continuous activity
      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      
      // Simulate quiz answers with intervals
      for (int i = 0; i < 3; i++) {
        await _answerQuizQuestion(tester, i);
        await tester.pump(Duration(seconds: 3)); // Wait 3 seconds between answers
        
        // Verify that autosave was triggered
        expect(progressProvider.progressState, anyOf([ProgressState.saving, ProgressState.saved]),
          reason: 'Autosave should trigger automatically every few seconds');
      }
      
      print('✅ QA-002: Automatic autosave working correctly');
    });

    testWidgets('QA-003: Offline recovery and synchronization', (WidgetTester tester) async {
      print('🧪 QA-003: Testing offline recovery...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Simulate connection loss
      await _simulateOfflineMode(tester);
      
      // Make progress while offline
      await _navigateToReading(tester);
      await _makeReadingProgress(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify that progress is saved locally
      final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(progressProvider.hasPendingProgress, true,
        reason: 'There should be pending progress to synchronize');

      // Simulate connection recovery
      await _simulateOnlineMode(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify automatic synchronization
      expect(progressProvider.hasPendingProgress, false,
        reason: 'Pending progress should have been synchronized');
      expect(progressProvider.progressState, ProgressState.saved,
        reason: 'Progress should be saved after synchronization');
      
      print('✅ QA-003: Offline recovery and synchronization successful');
    });

    testWidgets('QA-004: Data persistence in SharedPreferences', (WidgetTester tester) async {
      print('🧪 QA-004: Testing data persistence...');
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await _performLogin(tester);
      await tester.pumpAndSettle();

      // Make progress in multiple modules
      await _makeProgressInAllModules(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify that data was saved in SharedPreferences
      final savedAuthData = prefs.getString('user_data');
      final savedProgressData = prefs.getString('pending_progress');
      
      expect(savedAuthData, isNotNull, reason: 'Authentication data should persist');
      expect(savedProgressData, isNotNull, reason: 'Progress should persist locally');

      // Simulate complete app restart
      await _simulateCompleteAppRestart(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify that data was recovered correctly
      final authProvider = Provider.of<AuthProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(authProvider.user, isNotNull, reason: 'User data should be recovered');
      
      print('✅ QA-004: Data persistence verified');
    });
  });
}

// Helper methods for tests
Future<void> _performLogin(WidgetTester tester) async {
  // Find login fields
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

Future<void> _makeVocabularyProgress(WidgetTester tester) async {
  // Simulate word learning
  for (int i = 0; i < 3; i++) {
    final learnButton = find.byKey(Key('learn_word_button'));
    if (learnButton.evaluate().isNotEmpty) {
      await tester.tap(learnButton);
      await tester.pump(Duration(seconds: 1));
    }
  }
}

Future<void> _navigateToQuiz(WidgetTester tester) async {
  final quizButton = find.byKey(Key('quiz_module'));
  if (quizButton.evaluate().isNotEmpty) {
    await tester.tap(quizButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _answerQuizQuestion(WidgetTester tester, int questionIndex) async {
  final answerButton = find.byKey(Key('quiz_answer_0')); // Always answer the first option
  if (answerButton.evaluate().isNotEmpty) {
    await tester.tap(answerButton);
    await tester.pump(Duration(milliseconds: 500));
  }
}

Future<void> _navigateToReading(WidgetTester tester) async {
  final readingButton = find.byKey(Key('reading_module'));
  if (readingButton.evaluate().isNotEmpty) {
    await tester.tap(readingButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _makeReadingProgress(WidgetTester tester) async {
  // Simulate reading paragraphs
  final nextButton = find.byKey(Key('next_paragraph'));
  for (int i = 0; i < 2; i++) {
    if (nextButton.evaluate().isNotEmpty) {
      await tester.tap(nextButton);
      await tester.pump(Duration(seconds: 1));
    }
  }
}

Future<void> _makeProgressInAllModules(WidgetTester tester) async {
  await _navigateToVocabulary(tester);
  await _makeVocabularyProgress(tester);
  
  await _navigateToQuiz(tester);
  await _answerQuizQuestion(tester, 0);
  
  await _navigateToReading(tester);
  await _makeReadingProgress(tester);
}

Future<void> _simulateAppRestart(WidgetTester tester) async {
  // Simulate app restart while maintaining SharedPreferences
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/shared_preferences'),
    null,
  );
  
  app.main();
  await tester.pumpAndSettle(Duration(seconds: 2));
}

Future<void> _simulateCompleteAppRestart(WidgetTester tester) async {
  // Complete restart including providers
  app.main();
  await tester.pumpAndSettle(Duration(seconds: 3));
}

Future<void> _simulateOfflineMode(WidgetTester tester) async {
  // Simulate connection loss
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  progressProvider.setOfflineMode(true);
}

Future<void> _simulateOnlineMode(WidgetTester tester) async {
  // Simulate connection recovery
  final progressProvider = Provider.of<ProgressProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  progressProvider.setOfflineMode(false);
  await progressProvider.syncPendingProgress();
}

Future<void> _verifyProgressPersistence(WidgetTester tester) async {
  // Verify that previous progress is maintained
  await _navigateToVocabulary(tester);
  await tester.pumpAndSettle();
  
  final vocabProvider = Provider.of<VocabularyProvider>(tester.element(find.byType(MaterialApp)), listen: false);
  expect(vocabProvider.currentWordIndex, greaterThan(0), 
    reason: 'Vocabulary progress should be maintained');
}