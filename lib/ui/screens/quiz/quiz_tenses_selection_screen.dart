import 'package:flutter/material.dart';
import 'package:grammar_polisher/utils/quiz_state_manager.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:go_router/go_router.dart';

class QuizTensesSelectionScreen extends StatelessWidget {
  const QuizTensesSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizStateManager = QuizStateManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trắc nghiệm với Các thì'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          QuizTenseTile(title: 'Hiện tại đơn', quizKey: 'simple_present_quiz'),
          QuizTenseTile(
              title: 'Hiện tại tiếp diễn', quizKey: 'present_continuous_quiz'),
          QuizTenseTile(
              title: 'Hiện tại hoàn thành', quizKey: 'present_perfect_quiz'),
          QuizTenseTile(
              title: 'Hiện tại hoàn thành tiếp diễn',
              quizKey: 'present_perfect_continuous_quiz'),
          QuizTenseTile(title: 'Quá khứ đơn', quizKey: 'past_simple_quiz'),
          QuizTenseTile(
              title: 'Quá khứ tiếp diễn', quizKey: 'past_continuous_quiz'),
          QuizTenseTile(
              title: 'Quá khứ hoàn thành', quizKey: 'past_perfect_quiz'),
          QuizTenseTile(
              title: 'Quá khứ hoàn thành tiếp diễn',
              quizKey: 'past_perfect_continuous_quiz'),
          QuizTenseTile(title: 'Tương lai đơn', quizKey: 'future_simple_quiz'),
          QuizTenseTile(
              title: 'Tương lai tiếp diễn', quizKey: 'future_continuous_quiz'),
          QuizTenseTile(
              title: 'Tương lai hoàn thành', quizKey: 'future_perfect_quiz'),
          QuizTenseTile(
              title: 'Tương lai hoàn thành tiếp diễn',
              quizKey: 'future_perfect_continuous_quiz'),
          QuizTenseTile(title: 'Tương lai gần', quizKey: 'near_future_quiz'),
        ],
      ),
    );
  }
}

class QuizTenseTile extends StatefulWidget {
  final String title;
  final String quizKey;
  const QuizTenseTile({super.key, required this.title, required this.quizKey});

  @override
  State<QuizTenseTile> createState() => _QuizTenseTileState();
}

class _QuizTenseTileState extends State<QuizTenseTile> {
  @override
  Widget build(BuildContext context) {
    final quizStateManager = QuizStateManager();
    final isCompleted = quizStateManager.hasQuizResult(widget.quizKey);
    final quizData = quizStateManager.getQuizResult(widget.quizKey);
    String subtitle = widget.quizKey == 'simple_present_quiz'
        ? 'Simple Present'
        : widget.quizKey == 'past_simple_quiz'
            ? 'Simple Past'
            : widget.quizKey == 'present_continuous_quiz'
                ? 'Present Continuous'
                : widget.quizKey == 'present_perfect_quiz'
                    ? 'Present Perfect'
                    : widget.quizKey == 'present_perfect_continuous_quiz'
                        ? 'Present Perfect Continuous'
                        : widget.quizKey == 'past_continuous_quiz'
                            ? 'Past Continuous'
                            : widget.quizKey == 'past_perfect_quiz'
                                ? 'Past Perfect'
                                : widget.quizKey ==
                                        'past_perfect_continuous_quiz'
                                    ? 'Past Perfect Continuous'
                                    : widget.quizKey == 'future_simple_quiz'
                                        ? 'Future Simple'
                                        : widget.quizKey ==
                                                'future_continuous_quiz'
                                            ? 'Future Continuous'
                                            : widget.quizKey ==
                                                    'future_perfect_quiz'
                                                ? 'Future Perfect'
                                                : widget.quizKey ==
                                                        'future_perfect_continuous_quiz'
                                                    ? 'Future Perfect Continuous'
                                                    : widget.quizKey ==
                                                            'near_future_quiz'
                                                        ? 'Near Future'
                                                        : '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              if (isCompleted) const SizedBox(height: 8),
              if (isCompleted)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await quizStateManager
                              .removeQuizResult(widget.quizKey);
                          dynamic quizOutcome = await context.push(
                            RoutePaths.quiz + '/${widget.quizKey}',
                          );
                          if (quizOutcome is Map<String, dynamic>) {
                            await quizStateManager.setQuizResult(
                                widget.quizKey, quizOutcome);
                            setState(() {}); // Refresh UI after new result
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
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (quizData == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Bạn chưa hoàn thành bài này!')),
                            );
                            return;
                          }
                          await context.push(
                            RoutePaths.quiz + '/quiz_result',
                            extra: {
                              'score': quizData['score'] ?? 0,
                              'totalQuestions': quizData['totalQuestions'] ?? 0,
                              'quizDuration':
                                  quizData['quizDuration'] ?? const Duration(),
                              'userAnswers': quizData['userAnswers'] ?? [],
                              'quizKey': widget.quizKey,
                            },
                          );
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('Xem'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.school,
              color: isCompleted ? Colors.green : Colors.blue,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            await quizStateManager.removeQuizResult(widget.quizKey);
            dynamic quizOutcome = await context.push(
              RoutePaths.quiz + '/${widget.quizKey}',
            );
            if (quizOutcome is Map<String, dynamic>) {
              await quizStateManager.setQuizResult(widget.quizKey, quizOutcome);
              setState(() {}); // Refresh UI after new result
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
}
