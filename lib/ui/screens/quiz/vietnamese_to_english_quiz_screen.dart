import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grammar_polisher/data/models/word.dart';
import 'package:grammar_polisher/ui/commons/base_page.dart';
import 'package:grammar_polisher/ui/commons/rounded_button.dart';
import 'package:grammar_polisher/data/repositories/oxford_words_repository.dart'; // Contains OxfordWordsRepositoryImpl
import 'package:grammar_polisher/data/data_sources/assets_data.dart'; // Contains AssetsDataImpl
import 'package:grammar_polisher/data/data_sources/local_data.dart'; // Contains HiveDatabase (LocalDataImpl)
import 'package:grammar_polisher/configs/hive/app_hive.dart';
import 'package:grammar_polisher/ui/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:grammar_polisher/utils/quiz_state_manager.dart';

class VietnameseToEnglishQuizScreen extends StatefulWidget {
  const VietnameseToEnglishQuizScreen({super.key});

  @override
  State<VietnameseToEnglishQuizScreen> createState() =>
      _VietnameseToEnglishQuizScreenState();
}

class _VietnameseToEnglishQuizScreenState
    extends State<VietnameseToEnglishQuizScreen> {
  List<Word> _allWords = [];
  Word? _currentWord;
  List<String> _options = [];
  String? _selectedOption;
  String? _feedbackMessage;
  bool _showAnswer = false;
  int _score = 0;
  int _questionCount = 0;
  final int _numberOfQuestions = 10; // Number of questions per quiz session
  final int _numberOfOptions = 4; // Number of answer options
  DateTime _quizStartTime = DateTime.now();
  List<String> _userAnswers = [];
  List<Map<String, dynamic>> _questionDetails = [];

  @override
  void initState() {
    super.initState();
    _quizStartTime = DateTime.now();
    _userAnswers = [];
    _loadWordsAndStartQuiz();
  }

  Future<void> _loadWordsAndStartQuiz() async {
    final oxfordWordsRepository = OxfordWordsRepositoryImpl(
      assetsData: AssetsDataImpl(),
      localData: HiveDatabase(appHive: AppHive()),
    );
    _allWords = await oxfordWordsRepository.getAllOxfordWords();
    if (_allWords.isNotEmpty) {
      _generateQuestion();
    } else {
      setState(() {
        _feedbackMessage = "Không có từ nào để luyện tập.";
      });
    }
  }

  void _generateQuestion() {
    if (_questionCount >= _numberOfQuestions) {
      _endQuiz();
      return;
    }

    setState(() {
      _showAnswer = false;
      _selectedOption = null;
      _feedbackMessage = null;

      // Select a random word for the question
      _currentWord = _allWords[Random().nextInt(_allWords.length)];

      // Get the correct English word
      final correctAnswer = _currentWord!.word;

      // Get the Vietnamese definition (assuming first sense has a definition)
      final vietnameseDefinition = _currentWord!.senses.isNotEmpty
          ? _currentWord!.senses.first.definition
          : "Không có định nghĩa tiếng Việt"; // Fallback

      _options.clear();
      _options.add(correctAnswer);

      // Add incorrect options
      while (_options.length < _numberOfOptions) {
        final randomWord = _allWords[Random().nextInt(_allWords.length)];
        if (randomWord.word != correctAnswer &&
            !_options.contains(randomWord.word)) {
          _options.add(randomWord.word);
        }
      }
      _options.shuffle();

      // Lưu chi tiết câu hỏi vào _questionDetails
      _questionDetails.add({
        'question': vietnameseDefinition,
        'options': List<String>.from(_options),
        'correctAnswer': correctAnswer,
        'userAnswer': null, // sẽ cập nhật sau khi người dùng chọn
      });
    });
    _questionCount++;
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _selectedOption = selectedAnswer;
      _showAnswer = true;
      _userAnswers.add(selectedAnswer);
      if (_questionDetails.isNotEmpty) {
        _questionDetails[_questionCount - 1]['userAnswer'] = selectedAnswer;
      }
      if (selectedAnswer == _currentWord!.word) {
        _feedbackMessage = "Chính xác!";
        _score++;
      } else {
        _feedbackMessage = "Sai rồi. Đáp án đúng: ${_currentWord!.word}";
      }
    });
  }

  void _nextQuestion() {
    _generateQuestion();
  }

  void _endQuiz() async {
    if (!mounted) return;
    final quizResult = {
      'score': _score,
      'totalQuestions': _numberOfQuestions,
      'quizDuration': DateTime.now().difference(_quizStartTime),
      'userAnswers': _userAnswers,
      'quizKey': 'vietnamese_to_english_quiz',
      'questionDetails': _questionDetails,
    };
    await QuizStateManager()
        .setQuizResult('vietnamese_to_english_quiz', quizResult);
    Future.delayed(Duration.zero, () {
      context.go(
        '/quiz/quiz_result',
        extra: quizResult,
      );
    });
  }

  bool get isLastQuestion => _questionDetails.length >= _numberOfQuestions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_allWords.isEmpty && _feedbackMessage == null) {
      return const BasePage(
        title: "Luyện tập từ vựng",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return BasePage(
      title: "Luyện tập từ vựng",
      child: _currentWord == null
          ? Center(
              child: Text(_feedbackMessage ?? "Đang tải...",
                  style: textTheme.headlineSmall))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Câu hỏi $_questionCount / $_numberOfQuestions",
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _currentWord!.senses.isNotEmpty
                            ? _currentWord!.senses.first.definition
                            : "Không có định nghĩa tiếng Việt",
                        style: textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: _options.map((option) {
                        bool isCorrect = option == _currentWord!.word;
                        bool isSelected = option == _selectedOption;

                        // Determine button color based on state
                        Color buttonColor;
                        Color textColor = Colors.white;

                        if (_showAnswer) {
                          if (isCorrect) {
                            buttonColor = Colors.green[200]!;
                            textColor = Colors.black;
                          } else if (isSelected) {
                            buttonColor = Colors.red[200]!;
                            textColor = Colors.black;
                          } else {
                            buttonColor = Colors.grey[200]!;
                            textColor = Colors.black;
                          }
                        } else {
                          buttonColor = const Color(
                              0xFF3A5998); // Blue color from screenshot
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                            onTap:
                                _showAnswer ? null : () => _checkAnswer(option),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (_showAnswer)
                      Text(
                        _feedbackMessage!,
                        style: TextStyle(
                          fontSize: 16,
                          color: _feedbackMessage!.contains('Chính xác')
                              ? Colors.green
                              : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _showAnswer
                          ? (isLastQuestion ? _endQuiz : _nextQuestion)
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _showAnswer
                              ? const Color(0xFF3A5998)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          isLastQuestion ? "Kết thúc" : "Tiếp theo",
                          style: TextStyle(
                            fontSize: 16,
                            color: _showAnswer ? Colors.white : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
