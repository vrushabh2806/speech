import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_voice_todo/services/feedback_service.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService();
});
