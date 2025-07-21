import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:grammar_polisher/ui/screens/quiz/quiz_result_screen.dart'; // For displaying results
import 'package:grammar_polisher/utils/quiz_state_manager.dart'; // Import QuizStateManager
import 'package:grammar_polisher/ui/screens/quiz/quiz_tenses_selection_screen.dart';

class QuizSelectionScreen extends StatefulWidget {
  const QuizSelectionScreen({super.key});

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  final _quizStateManager = QuizStateManager();

  final String simplePresentQuizKey = 'simple_present_quiz';
  final String vietnameseToEnglishQuizKey = 'vietnamese_to_english_quiz';

  @override
  void initState() {
    super.initState();
    _initQuizState();
  }

  Future<void> _initQuizState() async {
    await _quizStateManager.init();
  }

  // Đưa hàm _handleRetryQuiz ra ngoài để dùng chung
  Future<void> _handleRetryQuiz(String retryQuizKey) async {
    await _quizStateManager.removeQuizResult(retryQuizKey);
    final result = await context.push<dynamic>(
      retryQuizKey == simplePresentQuizKey
          ? RoutePaths.quiz + '/simple_present_quiz'
          : retryQuizKey == 'past_simple_quiz'
              ? RoutePaths.quiz + '/past_simple_quiz'
              : retryQuizKey == 'present_continuous_quiz'
                  ? RoutePaths.quiz + '/present_continuous_quiz'
                  : retryQuizKey == 'present_perfect_quiz'
                      ? RoutePaths.quiz + '/present_perfect_quiz'
                      : retryQuizKey == 'present_perfect_continuous_quiz'
                          ? RoutePaths.quiz + '/present_perfect_continuous_quiz'
                          : retryQuizKey == 'past_continuous_quiz'
                              ? RoutePaths.quiz + '/past_continuous_quiz'
                              : retryQuizKey == 'past_perfect_quiz'
                                  ? RoutePaths.quiz + '/past_perfect_quiz'
                                  : retryQuizKey ==
                                          'past_perfect_continuous_quiz'
                                      ? RoutePaths.quiz +
                                          '/past_perfect_continuous_quiz'
                                      : retryQuizKey == 'future_simple_quiz'
                                          ? RoutePaths.quiz +
                                              '/future_simple_quiz'
                                          : retryQuizKey ==
                                                  'future_continuous_quiz'
                                              ? RoutePaths.quiz +
                                                  '/future_continuous_quiz'
                                              : retryQuizKey ==
                                                      'future_perfect_quiz'
                                                  ? RoutePaths.quiz +
                                                      '/future_perfect_quiz'
                                                  : retryQuizKey ==
                                                          'future_perfect_continuous_quiz'
                                                      ? RoutePaths.quiz +
                                                          '/future_perfect_continuous_quiz'
                                                      : retryQuizKey ==
                                                              'near_future_quiz'
                                                          ? RoutePaths.quiz +
                                                              '/near_future_quiz'
                                                          : RoutePaths.quiz +
                                                              '/vietnamese_to_english_quiz',
    );
    if (result is Map<String, dynamic>) {
      await _quizStateManager.setQuizResult(retryQuizKey, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, Map<String, dynamic>>>(
      valueListenable: _quizStateManager.quizResults,
      builder: (context, quizResults, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Chọn bài luyện tập',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF466A92),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF466A92)),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildWowQuizTile(
                context,
                'Tìm từ cho định nghĩa',
                subtitle: 'Find the word for the definition',
                icon: Icons.search,
                iconColor: Colors.purple,
                quizKey: vietnameseToEnglishQuizKey,
                progress: 0.4, // giả lập tiến độ
              ),
              _buildWowQuizTile(
                context,
                'Trắc nghiệm với Các thì',
                subtitle: 'Tenses Quiz',
                icon: Icons.access_time,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QuizTensesSelectionScreen(),
                    ),
                  );
                },
                progress: 0.2, // giả lập tiến độ
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWowQuizTile(
    BuildContext context,
    String title, {
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    String? quizKey,
    VoidCallback? onTap,
    double progress = 0.0,
  }) {
    final quizStateManager = _quizStateManager;
    final isCompleted =
        quizKey != null && quizStateManager.hasQuizResult(quizKey);
    final colorScheme = Theme.of(context).colorScheme;
    final quizCardColor = colorScheme.primaryContainer;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: quizCardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          title: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              if (isCompleted) const SizedBox(height: 8),
              if (isCompleted)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await quizStateManager.removeQuizResult(quizKey!);
                          dynamic quizOutcome = await context.push(
                            RoutePaths.quiz + '/vietnamese_to_english_quiz',
                          );
                          if (quizOutcome is Map<String, dynamic>) {
                            await quizStateManager.setQuizResult(
                                quizKey, quizOutcome);
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Làm lại'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final result =
                              quizStateManager.getQuizResult(quizKey!);
                          if (result != null) {
                            await context.push(
                              RoutePaths.quiz + '/quiz_result',
                              extra: {
                                ...result,
                                'quizKey': quizKey,
                              },
                            );
                          }
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('Xem'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          trailing: isCompleted ? null : const Icon(Icons.chevron_right),
          onTap: isCompleted
              ? null
              : onTap ??
                  () async {
                    dynamic quizOutcome = await context.push(
                      RoutePaths.quiz + '/vietnamese_to_english_quiz',
                    );
                    if (quizOutcome is Map<String, dynamic>) {
                      await quizStateManager.setQuizResult(
                          quizKey!, quizOutcome);
                      setState(() {});
                    }
                  },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizTile(
    BuildContext context,
    String title, {
    required String quizKey,
  }) {
    final isCompleted = _quizStateManager.hasQuizResult(quizKey);
    final quizData = _quizStateManager.getQuizResult(quizKey);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.left,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                quizKey == simplePresentQuizKey
                    ? 'Simple Present'
                    : quizKey == 'past_simple_quiz'
                        ? 'Simple Past'
                        : quizKey == 'present_continuous_quiz'
                            ? 'Present Continuous'
                            : quizKey == 'present_perfect_quiz'
                                ? 'Present Perfect'
                                : quizKey == 'present_perfect_continuous_quiz'
                                    ? 'Present Perfect Continuous'
                                    : quizKey == 'past_continuous_quiz'
                                        ? 'Past Continuous'
                                        : quizKey == 'past_perfect_quiz'
                                            ? 'Past Perfect'
                                            : quizKey ==
                                                    'past_perfect_continuous_quiz'
                                                ? 'Past Perfect Continuous'
                                                : quizKey ==
                                                        'future_simple_quiz'
                                                    ? 'Future Simple'
                                                    : quizKey ==
                                                            'future_continuous_quiz'
                                                        ? 'Future Continuous'
                                                        : quizKey ==
                                                                'future_perfect_quiz'
                                                            ? 'Future Perfect'
                                                            : quizKey ==
                                                                    'future_perfect_continuous_quiz'
                                                                ? 'Future Perfect Continuous'
                                                                : quizKey ==
                                                                        'near_future_quiz'
                                                                    ? 'Near Future'
                                                                    : 'Find the word for the definition',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCompleted) Icon(Icons.check_circle, color: Colors.green),
              if (isCompleted)
                ElevatedButton.icon(
                  onPressed: () async {
                    if (quizData == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Bạn chưa hoàn thành bài này!')),
                      );
                      return;
                    }
                    final result = await context.push(
                      RoutePaths.quiz + '/quiz_result',
                      extra: {
                        ...quizData,
                        'quizKey': quizKey,
                      },
                    );

                    if (result is Map && result['retry'] == true) {
                      await _handleRetryQuiz(result['quizKey'] ?? quizKey);
                    }
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Xem chi tiết'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              Icon(Icons.chevron_right),
            ],
          ),
          onTap: () async {
            bool shouldRetry = true;
            String currentQuizKey = quizKey;
            while (shouldRetry) {
              await _quizStateManager.removeQuizResult(currentQuizKey);
              dynamic quizOutcome = await context.push<dynamic>(
                currentQuizKey == simplePresentQuizKey
                    ? RoutePaths.quiz + '/simple_present_quiz'
                    : currentQuizKey == 'past_simple_quiz'
                        ? RoutePaths.quiz + '/past_simple_quiz'
                        : currentQuizKey == 'present_continuous_quiz'
                            ? RoutePaths.quiz + '/present_continuous_quiz'
                            : currentQuizKey == 'present_perfect_quiz'
                                ? RoutePaths.quiz + '/present_perfect_quiz'
                                : currentQuizKey ==
                                        'present_perfect_continuous_quiz'
                                    ? RoutePaths.quiz +
                                        '/present_perfect_continuous_quiz'
                                    : currentQuizKey == 'past_continuous_quiz'
                                        ? RoutePaths.quiz +
                                            '/past_continuous_quiz'
                                        : currentQuizKey == 'past_perfect_quiz'
                                            ? RoutePaths.quiz +
                                                '/past_perfect_quiz'
                                            : currentQuizKey ==
                                                    'past_perfect_continuous_quiz'
                                                ? RoutePaths.quiz +
                                                    '/past_perfect_continuous_quiz'
                                                : currentQuizKey ==
                                                        'future_simple_quiz'
                                                    ? RoutePaths.quiz +
                                                        '/future_simple_quiz'
                                                    : currentQuizKey ==
                                                            'future_continuous_quiz'
                                                        ? RoutePaths.quiz +
                                                            '/future_continuous_quiz'
                                                        : currentQuizKey ==
                                                                'future_perfect_quiz'
                                                            ? RoutePaths.quiz +
                                                                '/future_perfect_quiz'
                                                            : currentQuizKey ==
                                                                    'future_perfect_continuous_quiz'
                                                                ? RoutePaths
                                                                        .quiz +
                                                                    '/future_perfect_continuous_quiz'
                                                                : currentQuizKey ==
                                                                        'near_future_quiz'
                                                                    ? RoutePaths
                                                                            .quiz +
                                                                        '/near_future_quiz'
                                                                    : RoutePaths
                                                                            .quiz +
                                                                        '/vietnamese_to_english_quiz',
              );

              if (quizOutcome is Map<String, dynamic>) {
                await _quizStateManager.setQuizResult(
                    currentQuizKey, quizOutcome);

                dynamic resultScreenAction = await context.push<dynamic>(
                  RoutePaths.quiz + '/quiz_result',
                  extra: {
                    ...quizOutcome,
                    'quizKey': currentQuizKey,
                  },
                );

                if (resultScreenAction is Map &&
                    resultScreenAction['retry'] == true) {
                  currentQuizKey =
                      resultScreenAction['quizKey'] ?? currentQuizKey;
                  shouldRetry = true;
                } else {
                  shouldRetry = false;
                }
              } else {
                shouldRetry = false;
              }
            }
          },
          isThreeLine: true,
          dense: false,
        ),
      ),
    );
  }
}
