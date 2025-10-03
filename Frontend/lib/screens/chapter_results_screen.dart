import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapter_evaluation.dart';
import '../widgets/chapter_evaluation_card.dart';
import 'evaluation_details_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/evaluation_provider.dart';

class ChapterResultsScreen extends StatefulWidget {
  const ChapterResultsScreen({super.key});

  @override
  State<ChapterResultsScreen> createState() => _ChapterResultsScreenState();
}

class _ChapterResultsScreenState extends State<ChapterResultsScreen> {
  // Campos del branch main (se conservan por compatibilidad; el flujo usa Provider)
  List<ChapterEvaluation> evaluations = [];
  bool isLoading = true;

  String? selectedChapter;

  @override
  void initState() {
    super.initState();
    // Cargamos tras primer frame usando Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvaluations();
    });
  }

  Future<void> _loadEvaluations() async {
    final evaluationProvider =
        Provider.of<EvaluationProvider>(context, listen: false);
    await evaluationProvider.getChapterEvaluations();
  }

  List<ChapterEvaluation> _getFilteredEvaluations(
      List<ChapterEvaluation> evaluations) {
    if (selectedChapter == null) return evaluations;
    return evaluations
        .where((eval) => eval.chapterNumber.toString() == selectedChapter)
        .toList();
  }

  Set<String> _getAvailableChapters(List<ChapterEvaluation> evaluations) {
    return evaluations.map((eval) => eval.chapterNumber.toString()).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Consumer<EvaluationProvider>(
      builder: (context, evaluationProvider, child) {
        final evaluations = evaluationProvider.evaluations;
        final filteredEvaluations = _getFilteredEvaluations(evaluations);
        final availableChapters = _getAvailableChapters(evaluations);
        final isLoading = evaluationProvider.isLoading;

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
              ? const Center(child: CircularProgressIndicator())
              : evaluationProvider.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color:
                                theme.colorScheme.error.withOpacity(0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.unknownError,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            evaluationProvider.errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error
                                  .withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                evaluationProvider.getChapterEvaluations(),
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.tryAgain),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          evaluationProvider.refreshEvaluations(),
                      child: filteredEvaluations.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.assessment_outlined,
                                    size: 64,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noEvaluationsFound,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.completeChaptersToSeeResults,
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
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
                                final evaluation =
                                    filteredEvaluations[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: ChapterEvaluationCard(
                                    evaluation: evaluation,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EvaluationDetailsScreen(
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
      },
    );
  }
}
