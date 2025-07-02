import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuizStateManager {
  static final QuizStateManager _instance = QuizStateManager._internal();
  final ValueNotifier<Map<String, Map<String, dynamic>>> _quizResults =
      ValueNotifier({});
  final ValueNotifier<bool> _isQuizInProgressNotifier = ValueNotifier(false);
  static const String _quizResultsKey = 'quiz_results';

  factory QuizStateManager() {
    return _instance;
  }

  QuizStateManager._internal();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultsJson = prefs.getString(_quizResultsKey);
    if (resultsJson != null) {
      try {
        final Map<String, dynamic> decodedResults = json.decode(resultsJson);
        final Map<String, Map<String, dynamic>> typedResults = {};

        decodedResults.forEach((key, value) {
          if (value is Map) {
            typedResults[key] = Map<String, dynamic>.from(value);
          }
        });

        _quizResults.value = typedResults;
      } catch (e) {
        print('Error loading quiz results: $e');
      }
    }
  }

  ValueNotifier<bool> get isQuizInProgressNotifier => _isQuizInProgressNotifier;
  ValueNotifier<Map<String, Map<String, dynamic>>> get quizResults =>
      _quizResults;

  Map<String, dynamic>? getQuizResult(String quizKey) {
    return _quizResults.value[quizKey];
  }

  Future<void> setQuizResult(
      String quizKey, Map<String, dynamic> result) async {
    final newResults =
        Map<String, Map<String, dynamic>>.from(_quizResults.value);
    newResults[quizKey] = result;
    _quizResults.value = newResults;
    await _saveToPrefs();
  }

  Future<void> removeQuizResult(String quizKey) async {
    final newResults =
        Map<String, Map<String, dynamic>>.from(_quizResults.value);
    newResults.remove(quizKey);
    _quizResults.value = newResults;
    await _saveToPrefs();
  }

  bool hasQuizResult(String quizKey) {
    return _quizResults.value.containsKey(quizKey) &&
        _quizResults.value[quizKey] != null;
  }

  void setQuizInProgress(bool inProgress) {
    _isQuizInProgressNotifier.value = inProgress;
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String resultsJson = json.encode(_quizResults.value);
      await prefs.setString(_quizResultsKey, resultsJson);
    } catch (e) {
      print('Error saving quiz results: $e');
    }
  }
}
