import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../models/chapter_evaluation.dart';
import '../widgets/chapter_evaluation_card.dart';
import 'evaluation_details_screen.dart';
import '../l10n/app_localizations.dart';

class ChapterResultsScreen extends StatefulWidget {
  const ChapterResultsScreen({super.key});

  @override
  State<ChapterResultsScreen> createState() => _ChapterResultsScreenState();
}

class _ChapterResultsScreenState extends State<ChapterResultsScreen> {
  List<ChapterEvaluation> evaluations = [];
  bool isLoading = true;
  String? selectedChapter;

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  Future<void> _loadEvaluations() async {
    setState(() {
      isLoading = true;
    });

    // TODO: Implementar carga real de datos desde el backend
    await Future.delayed(const Duration(seconds: 1));
    
    // Datos de ejemplo
    evaluations = [
      ChapterEvaluation(
        id: '1',
        chapterNumber: 1,
        chapterTitle: 'Basic Greetings',
        score: 85,
        maxScore: 100,
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        status: EvaluationStatus.passed,
        attempts: 1,
        timeSpent: const Duration(minutes: 15),
      ),
      ChapterEvaluation(
        id: '2',
        chapterNumber: 2,
        chapterTitle: 'Introducing Yourself',
        score: 72,
        maxScore: 100,
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: EvaluationStatus.needsImprovement,
        attempts: 2,
        timeSpent: const Duration(minutes: 22),
      ),
      ChapterEvaluation(
        id: '3',
        chapterNumber: 3,
        chapterTitle: 'Daily Conversations',
        score: 95,
        maxScore: 100,
        completedAt: DateTime.now(),
        status: EvaluationStatus.excellent,
        attempts: 1,
        timeSpent: const Duration(minutes: 18),
      ),
    ];

    setState(() {
      isLoading = false;
    });
  }

  List<ChapterEvaluation> get filteredEvaluations {
    if (selectedChapter == null) return evaluations;
    return evaluations.where((eval) => eval.chapterNumber.toString() == selectedChapter).toList();
  }

  Set<String> get availableChapters {
    return evaluations.map((eval) => eval.chapterNumber.toString()).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(l10n.chapterResults),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                selectedChapter = value == 'all' ? null : value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Text(l10n.allChapters),
              ),
              ...availableChapters.map(
                (chapter) => PopupMenuItem(
                  value: chapter,
                  child: Text('${l10n.chapter} $chapter'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadEvaluations,
              child: filteredEvaluations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assessment_outlined,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noEvaluationsFound,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.completeChaptersToSeeResults,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEvaluations.length,
                      itemBuilder: (context, index) {
                        final evaluation = filteredEvaluations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ChapterEvaluationCard(
                            evaluation: evaluation,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EvaluationDetailsScreen(
                                    evaluation: evaluation,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}