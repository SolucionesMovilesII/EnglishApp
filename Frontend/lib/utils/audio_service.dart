import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  
  factory AudioService() => _instance;
  
  AudioService._internal();
  
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  
  Future<void> _initTts() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    
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
  
  Future<bool> speakText(String text, {String? language}) async {
    try {
      await _initTts();
      
      if (_flutterTts == null) return false;
      
      // Set language if provided
      if (language != null) {
        await _flutterTts!.setLanguage(language);
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
  
  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
  }
  
  Future<void> pause() async {
    if (_flutterTts != null) {
      await _flutterTts!.pause();
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
    _isInitialized = false;
  }
}