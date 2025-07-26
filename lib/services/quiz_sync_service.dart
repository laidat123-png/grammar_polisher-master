import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grammar_polisher/utils/quiz_state_manager.dart';

class QuizSyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sync quiz results from Firestore to local storage when user logs in
  static Future<void> syncQuizResultsFromFirestore() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print('No user logged in, skipping sync');
        return;
      }

      print('Syncing quiz results for user: ${user.email}');

      // Get user's quiz results from Firestore
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .orderBy('completedAt', descending: true)
          .get();

      final QuizStateManager quizStateManager = QuizStateManager();

      // Group results by quizKey to get the latest result for each quiz type
      Map<String, QueryDocumentSnapshot> latestResults = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String quizKey = data['quizKey'] ?? '';

        if (quizKey.isNotEmpty) {
          // Keep only the latest result for each quiz type
          if (!latestResults.containsKey(quizKey)) {
            latestResults[quizKey] = doc;
          }
        }
      }

      // Convert Firestore data to local format and save to QuizStateManager
      for (var entry in latestResults.entries) {
        final String quizKey = entry.key;
        final QueryDocumentSnapshot doc = entry.value;
        final data = doc.data() as Map<String, dynamic>;

        // Convert Firestore format to local QuizStateManager format
        final Map<String, dynamic> localResult = {
          'score': data['score'] ?? 0,
          'totalQuestions': data['totalQuestions'] ?? 0,
          'quizDuration': _convertDuration(data['duration']),
          'userAnswers': List<String>.from(data['userAnswers'] ?? []),
          'quizKey': quizKey,
          'questionDetails':
              List<Map<String, dynamic>>.from(data['questionDetails'] ?? []),
          // Additional fields for compatibility
          'percentage': data['percentage'] ?? 0,
          'grade': data['grade'] ?? 'F',
          'completedAt': data['completedAt'],
        };

        // Save to local QuizStateManager
        await quizStateManager.setQuizResult(quizKey, localResult);
        print(
            'Synced quiz result for: $quizKey (Score: ${data['score']}/${data['totalQuestions']})');
      }

      print(
          'Quiz sync completed. Synced ${latestResults.length} quiz results.');
    } catch (e) {
      print('Error syncing quiz results: $e');
    }
  }

  /// Convert Firestore duration format to Flutter Duration
  static Duration _convertDuration(dynamic durationData) {
    if (durationData == null) return Duration.zero;

    if (durationData is Map) {
      final int totalSeconds = durationData['totalSeconds'] ?? 0;
      return Duration(seconds: totalSeconds);
    }

    return Duration.zero;
  }

  /// Clear local quiz data (useful when user logs out)
  static Future<void> clearLocalQuizData() async {
    try {
      final QuizStateManager quizStateManager = QuizStateManager();

      // Get all current quiz keys
      final currentResults = quizStateManager.quizResults.value;

      // Remove all quiz results
      for (String quizKey in currentResults.keys) {
        await quizStateManager.removeQuizResult(quizKey);
      }

      print('Cleared all local quiz data');
    } catch (e) {
      print('Error clearing local quiz data: $e');
    }
  }

  /// Force sync a specific quiz result from Firestore
  static Future<void> syncSpecificQuizResult(String quizKey) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      // Get the latest result for this specific quiz
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .where('quizKey', isEqualTo: quizKey)
          .orderBy('completedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        final Map<String, dynamic> localResult = {
          'score': data['score'] ?? 0,
          'totalQuestions': data['totalQuestions'] ?? 0,
          'quizDuration': _convertDuration(data['duration']),
          'userAnswers': List<String>.from(data['userAnswers'] ?? []),
          'quizKey': quizKey,
          'questionDetails':
              List<Map<String, dynamic>>.from(data['questionDetails'] ?? []),
          'percentage': data['percentage'] ?? 0,
          'grade': data['grade'] ?? 'F',
          'completedAt': data['completedAt'],
        };

        final QuizStateManager quizStateManager = QuizStateManager();
        await quizStateManager.setQuizResult(quizKey, localResult);

        print('Synced specific quiz result for: $quizKey');
      }
    } catch (e) {
      print('Error syncing specific quiz result: $e');
    }
  }

  /// Check if user has quiz results in Firestore
  static Future<bool> hasFirestoreQuizResults() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking Firestore quiz results: $e');
      return false;
    }
  }
}
