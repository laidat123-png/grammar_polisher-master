import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResultService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save quiz result to Firestore
  static Future<void> saveQuizResult({
    required String quizType,
    required String quizKey,
    required int score,
    required int totalQuestions,
    required Duration quizDuration,
    List<String>? userAnswers,
    List<Map<String, dynamic>>? questionDetails,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final double percentage = (score / totalQuestions * 100);
      final String grade = _calculateGrade(percentage);

      final Map<String, dynamic> quizResult = {
        'userId': user.uid,
        'userEmail': user.email,
        'quizType': quizType, // e.g., "Simple Present", "Past Simple"
        'quizKey': quizKey, // e.g., "simple_present_quiz"
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': percentage.round(),
        'grade': grade,
        'duration': {
          'minutes': quizDuration.inMinutes,
          'seconds': quizDuration.inSeconds.remainder(60),
          'totalSeconds': quizDuration.inSeconds,
        },
        'userAnswers': userAnswers ?? [],
        'questionDetails': questionDetails ?? [],
        'completedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to user's quiz results collection
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .add(quizResult);

      // Also save to global quiz results for analytics
      await _firestore.collection('quiz_results').add(quizResult);

      // Update user statistics
      await _updateUserStats(
          user.uid, quizType, score, totalQuestions, percentage);
    } catch (e) {
      print('Error saving quiz result: $e');
      rethrow;
    }
  }

  /// Calculate grade based on percentage
  static String _calculateGrade(double percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  /// Update user statistics
  static Future<void> _updateUserStats(
    String userId,
    String quizType,
    int score,
    int totalQuestions,
    double percentage,
  ) async {
    try {
      final DocumentReference userStatsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('statistics')
          .doc('quiz_stats');

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(userStatsRef);

        Map<String, dynamic> data = {};
        if (snapshot.exists) {
          data = snapshot.data() as Map<String, dynamic>;
        }

        // Initialize if not exists
        data['totalQuizzes'] = (data['totalQuizzes'] ?? 0) + 1;
        data['totalScore'] = (data['totalScore'] ?? 0) + score;
        data['totalQuestions'] = (data['totalQuestions'] ?? 0) + totalQuestions;

        // Calculate average
        data['averageScore'] =
            (data['totalScore'] / data['totalQuestions'] * 100).round();

        // Track best score
        if (data['bestScore'] == null || percentage > data['bestScore']) {
          data['bestScore'] = percentage.round();
          data['bestQuizType'] = quizType;
        }

        // Track quiz type statistics
        Map<String, dynamic> quizTypeStats = data['quizTypeStats'] ?? {};
        Map<String, dynamic> currentTypeStats = quizTypeStats[quizType] ??
            {
              'completed': 0,
              'totalScore': 0,
              'totalQuestions': 0,
              'bestScore': 0,
            };

        currentTypeStats['completed'] =
            (currentTypeStats['completed'] ?? 0) + 1;
        currentTypeStats['totalScore'] =
            (currentTypeStats['totalScore'] ?? 0) + score;
        currentTypeStats['totalQuestions'] =
            (currentTypeStats['totalQuestions'] ?? 0) + totalQuestions;

        double typeAverage = (currentTypeStats['totalScore'] /
            currentTypeStats['totalQuestions'] *
            100);
        currentTypeStats['averageScore'] = typeAverage.round();

        if (percentage > (currentTypeStats['bestScore'] ?? 0)) {
          currentTypeStats['bestScore'] = percentage.round();
        }

        quizTypeStats[quizType] = currentTypeStats;
        data['quizTypeStats'] = quizTypeStats;
        data['lastUpdated'] = FieldValue.serverTimestamp();

        transaction.set(userStatsRef, data, SetOptions(merge: true));
      });
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

  /// Get user's quiz history
  static Future<List<Map<String, dynamic>>> getUserQuizHistory(
      String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_results')
          .orderBy('completedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting quiz history: $e');
      return [];
    }
  }

  /// Get user statistics
  static Future<Map<String, dynamic>?> getUserStats(String userId) async {
    try {
      final DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('statistics')
          .doc('quiz_stats')
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }

  /// Get quiz leaderboard
  static Future<List<Map<String, dynamic>>> getLeaderboard({
    String? quizType,
    int limit = 10,
  }) async {
    try {
      Query query = _firestore.collection('quiz_results');

      if (quizType != null) {
        query = query.where('quizType', isEqualTo: quizType);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('percentage', descending: true)
          .orderBy('duration.totalSeconds', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }
}
