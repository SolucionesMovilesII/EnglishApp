import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/episode.dart';
import '../l10n/app_localizations.dart';

class EpisodeProvider with ChangeNotifier {
  final Chapter _currentChapter = Chapter.getSampleChapter();
  int? _selectedEpisodeId;

  Chapter get currentChapter => _currentChapter;
  int? get selectedEpisodeId => _selectedEpisodeId;

  Episode? getEpisodeById(int id) {
    try {
      return _currentChapter.episodes.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  bool canPlayEpisode(int episodeId) {
    final episode = getEpisodeById(episodeId);
    if (episode == null) return false;
    
    return episode.status == EpisodeStatus.completed || 
           episode.status == EpisodeStatus.current;
  }

  void selectEpisode(int episodeId) {
    if (canPlayEpisode(episodeId)) {
      _selectedEpisodeId = episodeId;
      notifyListeners();
    }
  }

  void playEpisode(int episodeId) {
    if (canPlayEpisode(episodeId)) {
      // TODO: Implement Play Episode Logic
      debugPrint('Playing episode $episodeId');
    }
  }

  String getTooltipMessage(BuildContext context, Episode episode) {
    switch (episode.status) {
      case EpisodeStatus.completed:
        return AppLocalizations.of(context)!.episodeCompleted;
      case EpisodeStatus.current:
        return AppLocalizations.of(context)!.continueEpisode;
      case EpisodeStatus.locked:
        return AppLocalizations.of(context)!.completePreviousEpisode;
    }
  }

  void completeEpisode(int episodeId) {
    // TODO: Implement Complete Episode Logic
    notifyListeners();
  }

  void updateProgress(int episodeId, double newProgress) {
    // TODO: Implement Update Episode Progress Logic
    notifyListeners();
  }
}