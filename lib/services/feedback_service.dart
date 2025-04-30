import 'package:flutter_tts/flutter_tts.dart';


class FeedbackService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  
  FeedbackService() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _isInitialized = true;
  }
  
  Future<void> speak(String message) async {
    if (!_isInitialized) await _initialize();
    await _tts.speak(message);
  }
  
  Future<void> stop() async {
    if (_isInitialized) {
      await _tts.stop();
    }
  }
}
