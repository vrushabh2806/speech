import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _isInitialized = await _speech.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );
    
    return _isInitialized;
  }
  
  Future<void> listen({
    required Function(String) onResult,
    Function()? onListeningComplete,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('Failed to initialize speech recognition');
        return;
      }
    }
    
    if (_speech.isListening) {
      await _speech.stop();
      onListeningComplete?.call();
      return;
    }
    
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
    );
  }
  
  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
  
  bool get isListening => _speech.isListening;
}
