import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grammar_polisher/services/quiz_sync_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initialize auth state listener
  static void initAuthStateListener() {
    _auth.authStateChanges().listen((User? user) async {
      final prefs = await SharedPreferences.getInstance();

      if (user == null) {
        // User is signed out
        print('User signed out, clearing local data');
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('isLoggedIn');

        // Clear quiz data when user signs out
        try {
          await QuizSyncService.clearLocalQuizData();
        } catch (e) {
          print('Error clearing quiz data on auth state change: $e');
        }
      } else {
        // User is signed in
        print('User signed in: ${user.email}');
        await prefs.setBool('isLoggedIn', true);

        // Sync quiz data when user signs in
        try {
          await QuizSyncService.syncQuizResultsFromFirestore();
          print('Quiz data synced on auth state change');
        } catch (e) {
          print('Error syncing quiz data on auth state change: $e');
        }
      }
    });
  }

  /// Check if user is currently authenticated
  static bool get isAuthenticated {
    return _auth.currentUser != null;
  }

  /// Get current user
  static User? get currentUser {
    return _auth.currentUser;
  }

  /// Sign out user and clear all local data
  static Future<void> signOut() async {
    try {
      // Clear local data first
      await QuizSyncService.clearLocalQuizData();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('isLoggedIn');

      // Sign out from Firebase (this will trigger the auth state listener)
      await _auth.signOut();

      print('User signed out successfully');
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set login status in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      return credential;
    } catch (e) {
      print('Error during email sign in: $e');
      rethrow;
    }
  }

  /// Sign in with Google
  static Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final credential = await _auth.signInWithProvider(googleProvider);

      // Set login status in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      return credential;
    } catch (e) {
      print('Error during Google sign in: $e');
      rethrow;
    }
  }
}
