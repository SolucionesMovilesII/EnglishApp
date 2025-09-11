import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reading_provider.dart';
import '../providers/progress_provider.dart';
import '../l10n/app_localizations.dart';

class ReadingScreen extends StatelessWidget {
  final String chapterId;
  
  const ReadingScreen({super.key, this.chapterId = 'reading-chapter-1'});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadingProvider(
        progressProvider: Provider.of<ProgressProvider>(context, listen: false),
        chapterId: chapterId,
      ),
      child: const _ReadingScreenContent(),
    );
  }
}

class _ReadingScreenContent extends StatelessWidget {
  const _ReadingScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reading),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Consumer<ReadingProvider>(
            builder: (context, readingProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${readingProvider.completionPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReadingProvider>(
        builder: (context, readingProvider, child) {
          return Column(
            children: [
              // Chapter Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      readingProvider.chapter.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Paragraph ${readingProvider.currentParagraphIndex + 1} of ${readingProvider.chapter.paragraphs.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: readingProvider.readingProgress,
                      backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Reading Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Paragraph Card
                      Card(
                        elevation: 4,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paragraph ${readingProvider.currentParagraph.paragraphNumber}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                readingProvider.currentParagraph.content,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Reading Complete Message
                      if (readingProvider.isReadingComplete && !readingProvider.isQuizComplete) ...[
                        Card(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.menu_book,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Reading Complete!',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Now take the quiz to complete this chapter.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _showQuizDialog(context, readingProvider),
                                  icon: const Icon(Icons.quiz),
                                  label: const Text('Take Quiz'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Chapter Complete Message
                      if (readingProvider.isChapterComplete) ...[
                        Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.celebration,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Chapter Complete! 🎉',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Quiz Score: ${readingProvider.quizScore}%',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Navigation Controls
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: readingProvider.currentParagraphIndex > 0
                          ? readingProvider.previousParagraph
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    
                    if (!readingProvider.isReadingComplete)
                      ElevatedButton.icon(
                        onPressed: !readingProvider.isLastParagraph
                            ? readingProvider.nextParagraph
                            : () {
                                readingProvider.nextParagraph(); // This will mark reading as complete
                              },
                        icon: Icon(readingProvider.isLastParagraph ? Icons.check : Icons.arrow_forward),
                        label: Text(readingProvider.isLastParagraph ? 'Finish' : 'Next'),
                        style: readingProvider.isLastParagraph
                            ? ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              )
                            : null,
                      ),
                    
                    if (readingProvider.isReadingComplete && !readingProvider.isQuizComplete)
                      ElevatedButton.icon(
                        onPressed: () => _showQuizDialog(context, readingProvider),
                        icon: const Icon(Icons.quiz),
                        label: const Text('Quiz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showQuizDialog(BuildContext context, ReadingProvider readingProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reading Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Answer the following questions based on the reading:'),
              const SizedBox(height: 16),
              ...readingProvider.chapter.quizQuestions.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Simulate quiz completion with random score
                final score = 75 + (25 * (readingProvider.currentParagraphIndex / readingProvider.chapter.paragraphs.length)).round();
                readingProvider.completeQuiz(score);
                Navigator.of(context).pop();
              },
              child: const Text('Complete Quiz'),
            ),
          ],
        );
      },
    );
  }
}