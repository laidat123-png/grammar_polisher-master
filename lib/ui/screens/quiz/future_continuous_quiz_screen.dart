import 'package:flutter/material.dart';
import 'package:grammar_polisher/data/quiz_data.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/navigation/app_router.dart';
import 'package:grammar_polisher/utils/quiz_state_manager.dart';

class FutureContinuousQuizScreen extends StatefulWidget {
  const FutureContinuousQuizScreen({super.key});

  @override
  State<FutureContinuousQuizScreen> createState() =>
      _FutureContinuousQuizScreenState();
}

class _FutureContinuousQuizScreenState
    extends State<FutureContinuousQuizScreen> {
  final _quizStateManager = QuizStateManager();
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  Timer? _timer;
  int _secondsRemaining = 10;
  late DateTime _quizStartTime;
  List<String> _userAnswers = [];
  bool _showHint = false; // Thêm biến để kiểm soát hiển thị mẹo nhớ

  @override
  void initState() {
    super.initState();
    _quizStateManager.setQuizInProgress(true);
    _quizStartTime = DateTime.now();
    _userAnswers = [];
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < futureContinuousQuestions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showHint = false; // Ẩn mẹo nhớ khi chuyển câu hỏi
        _startTimer();
      } else {
        _timer?.cancel();
        _showResultDialog();
      }
    });
  }

  void _checkAnswer(String selectedAnswer) {
    _timer?.cancel();
    setState(() {
      _selectedAnswer = selectedAnswer;
      _userAnswers.add(selectedAnswer);
      if (selectedAnswer ==
          futureContinuousQuestions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  // Thêm phương thức để tính số câu trả lời sai
  int _getWrongAnswers() {
    // Chỉ tính số câu đã trả lời (không tính câu hiện tại nếu chưa trả lời)
    int answeredQuestions = _selectedAnswer == null
        ? _currentQuestionIndex
        : _currentQuestionIndex + 1;
    return answeredQuestions - _score;
  }

  // Thêm phương thức để hiển thị/ẩn mẹo nhớ
  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  void _showResultDialog() {
    final quizEndTime = DateTime.now();
    final Duration quizDuration = quizEndTime.difference(_quizStartTime);

    final Map<String, dynamic> quizResult = {
      'score': _score,
      'totalQuestions': futureContinuousQuestions.length,
      'quizDuration': quizDuration,
      'userAnswers': _userAnswers,
      'quizKey': 'future_continuous_quiz',
    };
    context.pop(quizResult);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _quizStateManager.setQuizInProgress(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = futureContinuousQuestions[_currentQuestionIndex];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Thoát bài luyện tập'),
              content: const Text(
                  'Bạn có chắc chắn muốn thoát? Tiến trình của bạn sẽ bị mất.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Không'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Có'),
                ),
              ],
            );
          },
        );
        if (shouldExit == true) {
          if (mounted) {
            _quizStateManager.setQuizInProgress(false);
            context.pop();
          }
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _quizStateManager.isQuizInProgressNotifier,
        builder: (context, isQuizInProgress, child) {
          if (!isQuizInProgress && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.pop();
              }
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Luyện tập thì TLTD',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${futureContinuousQuestions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false, // Ẩn nút quay lại
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Thống kê
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: Colors.green[700],
                                                size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              '$_score/${_currentQuestionIndex + (_selectedAnswer != null ? 1 : 0)}',
                                              style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Đúng',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close,
                                                color: Colors.red[700],
                                                size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${_getWrongAnswers()}/${_currentQuestionIndex + (_selectedAnswer != null ? 1 : 0)}',
                                              style: TextStyle(
                                                color: Colors.red[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Sai',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _toggleHint,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.lightbulb_outline,
                                              color: Colors.amber[700],
                                              size: 18),
                                          Text(
                                            'Gợi ý',
                                            style: TextStyle(
                                              color: Colors.amber[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Câu hỏi và thanh tiến trình
                            Row(
                              children: [
                                Text(
                                  'Câu ${_currentQuestionIndex + 1}/${futureContinuousQuestions.length}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.timer,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${_secondsRemaining}s',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            LinearProgressIndicator(
                              value: _secondsRemaining / 10,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                              minHeight: 8,
                            ),

                            const SizedBox(height: 20),

                            // Card chứa câu hỏi và các lựa chọn
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      20.0), // Tăng padding từ 16 lên 20
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentQuestion.question,
                                        style: const TextStyle(
                                          fontSize:
                                              24, // Tăng kích thước chữ câu hỏi từ 20 lên 24
                                          fontWeight: FontWeight
                                              .w600, // Tăng độ đậm từ w500 lên w600
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              20), // Tăng khoảng cách từ 16 lên 20
                                      // ListView với các lựa chọn
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            currentQuestion.options.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                                height:
                                                    14), // Tăng khoảng cách từ 12 lên 14
                                        itemBuilder: (context, optIdx) {
                                          String option =
                                              currentQuestion.options[optIdx];
                                          bool isCorrect = (option ==
                                              currentQuestion.correctAnswer);
                                          bool isSelected =
                                              (option == _selectedAnswer);
                                          String label = String.fromCharCode(
                                              65 + optIdx); // A, B, C, D

                                          return InkWell(
                                            onTap: _selectedAnswer == null
                                                ? () => _checkAnswer(option)
                                                : null,
                                            borderRadius: BorderRadius.circular(
                                                14), // Tăng bo góc từ 12 lên 14
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical:
                                                    18, // Tăng padding dọc từ 16 lên 18
                                                horizontal:
                                                    18, // Tăng padding ngang từ 16 lên 18
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? (isCorrect
                                                        ? Colors.green[50]
                                                        : Colors.red[50])
                                                    : Colors.grey[100],
                                                borderRadius: BorderRadius.circular(
                                                    14), // Tăng bo góc từ 12 lên 14
                                                border: Border.all(
                                                  color: isSelected
                                                      ? (isCorrect
                                                          ? Colors.green
                                                          : Colors.red)
                                                      : Colors.grey.shade300,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '$label. ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          20, // Tăng kích thước chữ từ 18 lên 20
                                                      color: isSelected
                                                          ? (isCorrect
                                                              ? Colors
                                                                  .green[700]
                                                              : Colors.red[700])
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      option,
                                                      style: TextStyle(
                                                        fontSize:
                                                            20, // Tăng kích thước chữ từ 18 lên 20
                                                        color: isSelected
                                                            ? (isCorrect
                                                                ? Colors
                                                                    .green[700]
                                                                : Colors
                                                                    .red[700])
                                                            : Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    Icon(
                                                      isCorrect
                                                          ? Icons.check_circle
                                                          : Icons.cancel,
                                                      color: isCorrect
                                                          ? Colors.green
                                                          : Colors.red,
                                                      size:
                                                          24, // Tăng kích thước icon từ 22 lên 24
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Thêm khoảng cách để đẩy mẹo nhớ xuống dưới
                            const SizedBox(height: 16),

                            // Mẹo nhớ - hiển thị khi _showHint = true
                            if (_showHint)
                              Container(
                                padding: const EdgeInsets.all(
                                    16), // Tăng padding từ 12 lên 16
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.circular(
                                      16), // Tăng bo góc từ 12 lên 16
                                  border: Border.all(
                                      color: Colors.amber,
                                      width:
                                          1.5), // Tăng độ dày viền từ 1 lên 1.5
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lightbulb_outline,
                                            color: Colors.amber[800],
                                            size:
                                                20), // Tăng kích thước icon từ 16 lên 20
                                        const SizedBox(
                                            width:
                                                6), // Tăng khoảng cách từ 4 lên 6
                                        Text(
                                          'Mẹo nhớ:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                16, // Tăng kích thước chữ từ 14 lên 16
                                            color: Colors.amber[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Tăng khoảng cách từ 4 lên 8
                                    Text(
                                      'Thì tương lai tiếp diễn dùng để diễn tả hành động đang diễn ra tại một thời điểm xác định trong tương lai. Cấu trúc: S + will + be + V-ing. Thường đi với "at this time tomorrow", "at that moment", "this time next week".',
                                      style: TextStyle(
                                        color: Colors.amber[900],
                                        fontSize:
                                            15, // Tăng kích thước chữ từ 13 lên 15
                                        height:
                                            1.4, // Thêm line height để văn bản dễ đọc hơn
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
