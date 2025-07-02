import 'package:flutter/material.dart';
import '../../../data/data_sources/search_history_data.dart';
import '../../../data/models/search_history_item.dart';
import '../../commons/base_page.dart';
import 'package:get_it/get_it.dart';
import '../../../data/repositories/oxford_words_repository.dart';
import '../../../data/models/word.dart';
import 'word_details_screen.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/assets.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  late Future<List<SearchHistoryItem>> _historyFuture;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = SearchHistoryData().getHistory();
  }

  void _clearHistory() async {
    await SearchHistoryData().clearHistory();
    setState(() {
      _loadHistory();
    });
  }

  int _countTotalWords(List<SearchHistoryItem> history) {
    return history.length;
  }

  Widget _buildPosIcon(String pos) {
    final p = pos.toLowerCase();
    if (p.contains('noun'))
      return const Icon(Icons.menu_book, color: Colors.amber, size: 28);
    if (p.contains('verb'))
      return const Icon(Icons.edit, color: Colors.red, size: 28);
    if (p.contains('adjective'))
      return const Icon(Icons.brush, color: Colors.purple, size: 28);
    if (p.contains('adverb'))
      return const Icon(Icons.directions_run, color: Colors.blue, size: 28);
    if (p.contains('preposition'))
      return const Icon(Icons.arrow_right_alt,
          color: Colors.blueGrey, size: 28);
    return const Icon(Icons.help_outline, color: Colors.grey, size: 28);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BasePage(
          title: 'Lịch sử tra cứu',
          child: FutureBuilder<List<SearchHistoryItem>>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final history = snapshot.data ?? [];
              if (history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn chưa có lịch sử tra cứu nào.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/detective2.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                );
              }
              final wordsThisMonth = _countTotalWords(history);
              return Column(
                children: [
                  const SizedBox(height: 8),
                  // Tổng kết số từ đã tra cứu trong tháng
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bạn đã tra cứu $wordsThisMonth từ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _clearHistory,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Xóa lịch sử'),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 1.0),
                          duration: const Duration(milliseconds: 200),
                          builder: (context, scale, child) {
                            return GestureDetector(
                              onTapDown: (_) => setState(() {}),
                              onTapUp: (_) => setState(() {}),
                              onTapCancel: () => setState(() {}),
                              onTap: () async {
                                final repo = GetIt.I<OxfordWordsRepository>();
                                final words = repo.getAllOxfordWords();
                                final word = words.firstWhere(
                                  (w) =>
                                      w.word == item.word && w.pos == item.pos,
                                  orElse: () => words.isNotEmpty
                                      ? words.first
                                      : Word(word: item.word, pos: item.pos),
                                );
                                if (word != null) {
                                  await SearchHistoryData().addHistory(
                                    SearchHistoryItem(
                                        word: word.word,
                                        pos: word.pos,
                                        searchedAt: DateTime.now()),
                                  );
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          WordDetailsScreen(word: word),
                                    ),
                                  );
                                  setState(_loadHistory);
                                }
                              },
                              child: AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 120),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE3F2FD),
                                        Color(0xFFB2EBF2)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.10),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      _buildPosIcon(item.pos),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.word,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text('Tra cứu lúc: '
                                                "${item.searchedAt.toLocal().toString().substring(0, 19)}"),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        item.pos,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: _getPosColor(item.pos),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getPosColor(String pos) {
    final p = pos.toLowerCase();
    if (p.contains('noun')) return Colors.amber[800]!;
    if (p.contains('verb')) return Colors.red;
    if (p.contains('adjective')) return Colors.purple;
    if (p.contains('adverb')) return Colors.blue;
    return Colors.blueGrey;
  }
}
