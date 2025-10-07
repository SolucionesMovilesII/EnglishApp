import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  
  factory AudioService() => _instance;
  
  AudioService._internal();
  
  FlutterTts? _flutterTts;
  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;
  
  Future<void> _initTts() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();
    
    if (kIsWeb) {
      // Web-specific configuration
      await _flutterTts!.setSharedInstance(true);
    }
    
    // Set default configuration
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setPitch(1.0);
    
    _isInitialized = true;
  }
  
  // Static methods for backward compatibility
  static Future<bool> speak(String text, {String? language}) async {
    return await _instance.speakText(text, language: language);
  }
  
  static Future<void> playFromUrl(String url) async {
    await _instance.playAudioFromUrl(url);
  }
  
  Future<bool> speakText(String text, {String? language}) async {
    try {
      await _initTts();
      
      if (_flutterTts == null) return false;
      
      // Set language if provided
      if (language != null) {
        final supportedLanguage = getSupportedLanguage(language);
        await _flutterTts!.setLanguage(supportedLanguage);
      }
      
      // Speak the text
      final result = await _flutterTts!.speak(text);
      
      return result == 1; // 1 indicates success
    } catch (e) {
      if (kDebugMode) {
        print('AudioService error: $e');
      }
      return false;
    }
  }
  
  Future<void> playAudioFromUrl(String url) async {
    try {
      await _initTts();
      
      if (_audioPlayer == null) return;
      
      await _audioPlayer!.play(UrlSource(url));
    } catch (e) {
      if (kDebugMode) {
        print('AudioService playFromUrl error: $e');
      }
      // Fallback to TTS if URL playback fails
      rethrow;
    }
  }
  
  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
  }
  
  Future<void> pause() async {
    if (_flutterTts != null) {
      await _flutterTts!.pause();
    }
    if (_audioPlayer != null) {
      await _audioPlayer!.pause();
    }
  }
  
  String getSupportedLanguage(String languageCode) {
    // Map common language codes to TTS supported formats
    final languageMap = {
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh': 'zh-CN',
      'ar': 'ar-SA',
    };
    
    return languageMap[languageCode] ?? 'en-US';
  }
  
  Future<List<String>> getAvailableLanguages() async {
    try {
      await _initTts();
      
      if (_flutterTts == null) return [];
      
      final languages = await _flutterTts!.getLanguages;
      return List<String>.from(languages ?? []);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting available languages: $e');
      }
      return [];
    }
  }
  
  Future<void> setVolume(double volume) async {
    await _initTts();
    if (_flutterTts != null) {
      await _flutterTts!.setVolume(volume.clamp(0.0, 1.0));
    }
  }
  
  Future<void> setSpeechRate(double rate) async {
    await _initTts();
    if (_flutterTts != null) {
      await _flutterTts!.setSpeechRate(rate.clamp(0.0, 1.0));
    }
  }
  
  Future<void> setPitch(double pitch) async {
    await _initTts();
    if (_flutterTts != null) {
      await _flutterTts!.setPitch(pitch.clamp(0.5, 2.0));
    }
  }
  
  void dispose() {
    _flutterTts = null;
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _isInitialized = false;
  }
}