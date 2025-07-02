import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:grammar_polisher/data/quiz_data.dart';
import 'package:grammar_polisher/data/repositories/oxford_words_repository.dart';
import 'package:grammar_polisher/data/data_sources/assets_data.dart';
import 'package:grammar_polisher/data/data_sources/local_data.dart';
import 'package:grammar_polisher/configs/hive/app_hive.dart';
import 'package:grammar_polisher/data/models/word.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Duration quizDuration;
  final List<String>? userAnswers;
  final String? quizKey;
  final List<Map<String, dynamic>>? questionDetails;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.quizDuration,
    this.userAnswers,
    this.quizKey,
    this.questionDetails,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDuration =
        '${quizDuration.inMinutes} phút ${quizDuration.inSeconds.remainder(60)} giây';
    final List<QuizQuestion> questions = quizKey == 'past_simple_quiz'
        ? pastSimpleQuestions
        : quizKey == 'simple_present_quiz'
            ? simplePresentQuestions
            : quizKey == 'present_continuous_quiz'
                ? presentContinuousQuestions
                : quizKey == 'present_perfect_quiz'
                    ? presentPerfectQuestions
                    : quizKey == 'present_perfect_continuous_quiz'
                        ? presentPerfectContinuousQuestions
                        : quizKey == 'past_continuous_quiz'
                            ? pastContinuousQuestions
                            : quizKey == 'past_perfect_quiz'
                                ? pastPerfectQuestions
                                : quizKey == 'past_perfect_continuous_quiz'
                                    ? pastPerfectContinuousQuestions
                                    : quizKey == 'future_simple_quiz'
                                        ? futureSimpleQuestions
                                        : quizKey == 'future_continuous_quiz'
                                            ? futureContinuousQuestions
                                            : quizKey == 'future_perfect_quiz'
                                                ? futurePerfectQuestions
                                                : quizKey ==
                                                        'future_perfect_continuous_quiz'
                                                    ? futurePerfectContinuousQuestions
                                                    : quizKey ==
                                                            'near_future_quiz'
                                                        ? nearFutureQuestions
                                                        : [];

    final bool isVietnameseToEnglish = quizKey == 'vietnamese_to_english_quiz';

    List<Widget> resultWidgets = [];
    if (isVietnameseToEnglish &&
        userAnswers != null &&
        (quizKey == 'vietnamese_to_english_quiz')) {
      final List<Map<String, dynamic>>? details = questionDetails ??
          (() {
            final Map<String, dynamic>? extra = ModalRoute.of(context)
                ?.settings
                .arguments as Map<String, dynamic>?;
            final raw = extra != null ? extra['questionDetails'] : null;
            if (raw is List && raw.isNotEmpty && raw.first is Map) {
              return List<Map<String, dynamic>>.from(raw);
            }
            return null;
          })();
      if (details != null) {
        resultWidgets.addAll(details.asMap().entries.map((entry) {
          final int index = entry.key;
          final q = entry.value;
          final String question = q['question'] ?? '';
          final List options = q['options'] ?? [];
          final String correctAnswer = q['correctAnswer'] ?? '';
          final String userAnswer = q['userAnswer'] ?? '';
          final bool isCorrect = userAnswer == correctAnswer;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Câu ${index + 1}: $question',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...options.asMap().entries.map((optEntry) {
                    final int optIdx = optEntry.key;
                    final String opt = optEntry.value;
                    final bool isOptionCorrect = opt == correctAnswer;
                    final bool isOptionUser = opt == userAnswer;
                    Color? color;
                    if (isOptionCorrect) {
                      color = Colors.green[100];
                    } else if (isOptionUser && !isOptionCorrect) {
                      color = Colors.red[100];
                    }
                    final String label =
                        String.fromCharCode(65 + optIdx); // A, B, C, D
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Text('$label. ',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        title: Text(opt),
                        trailing: isOptionUser
                            ? Icon(
                                isOptionCorrect ? Icons.check : Icons.close,
                                color:
                                    isOptionCorrect ? Colors.green : Colors.red,
                              )
                            : isOptionCorrect
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }));
      } else {
        final oxfordWordsRepository = OxfordWordsRepositoryImpl(
          assetsData: AssetsDataImpl(),
          localData: HiveDatabase(appHive: AppHive()),
        );
        final allWords = oxfordWordsRepository.getAllOxfordWords();
        resultWidgets.addAll(List.generate(userAnswers!.length, (index) {
          final String userWord = userAnswers![index];
          String vietnameseDefinition = 'Không có dữ liệu đề';
          final found = allWords.firstWhere(
            (w) => w.word == userWord,
            orElse: () => Word(word: '', senses: []),
          );
          if (found.word.isNotEmpty && found.senses.isNotEmpty) {
            vietnameseDefinition = found.senses.first.definition;
          }
          // Đúng nếu nghĩa tiếng Việt của từ bạn chọn trùng với đề (gần đúng)
          final bool isCorrect =
              found.word.isNotEmpty && found.senses.isNotEmpty;
          final Color cardColor =
              isCorrect ? Colors.green[50]! : Colors.red[50]!;
          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Câu ${index + 1}: $vietnameseDefinition',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }));
      }
    } else {
      resultWidgets.addAll(List.generate(questions.length, (index) {
        final q = questions[index];
        final userAnswer = userAnswers != null && userAnswers!.length > index
            ? userAnswers![index]
            : null;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Câu ${index + 1}: ${q.question}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ...q.options.asMap().entries.map((entry) {
                  final int optIdx = entry.key;
                  final String opt = entry.value;
                  final bool isCorrect = opt == q.correctAnswer;
                  final bool isUser = opt == userAnswer;
                  Color? color;
                  if (isCorrect) {
                    color = Colors.green[100];
                  } else if (isUser && !isCorrect) {
                    color = Colors.red[100];
                  }
                  final String label =
                      String.fromCharCode(65 + optIdx); // A, B, C, D
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Text('$label. ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      title: Text(opt),
                      trailing: isUser || isCorrect
                          ? Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: isCorrect ? Colors.green : Colors.red,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả bài luyện tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Bạn đã đạt $score / $totalQuestions điểm',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Thời gian hoàn thành: $formattedDuration',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  ...resultWidgets,
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Đã xóa phần nút "Làm lại" và "Hoàn thành" ở đây
          ],
        ),
      ),
    );
  }
}
