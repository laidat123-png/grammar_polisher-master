import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../commons/base_page.dart';
import './bloc/vocabulary_bloc.dart';
import './widgets/vocabulary_item.dart';
import 'word_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavedWordsScreen extends StatefulWidget {
  const SavedWordsScreen({super.key});

  @override
  State<SavedWordsScreen> createState() => _SavedWordsScreenState();
}

class _SavedWordsScreenState extends State<SavedWordsScreen> {
  int? _tappedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        final savedWords = state.words
            .where((word) => word.userDefinition == 'favorite')
            .toList();

        return BasePage(
          title: 'Từ vựng yêu thích',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (savedWords.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final bloc = context.read<VocabularyBloc>();
                        for (final w in state.words
                            .where((w) => w.userDefinition == 'favorite')) {
                          final updated = w.copyWith(
                              userDefinition: null, addedToFavoriteAt: null);
                          bloc.add(VocabularyEvent.changeStatus(updated, null));
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Xóa yêu thích'),
                    ),
                  ),
                Expanded(
                  child: savedWords.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Bạn đã lưu ${savedWords.length} từ vựng! Tiếp tục duy trì nhé! 🎉',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: savedWords.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final word = savedWords[index];
                                  return GestureDetector(
                                    onTapDown: (_) => setState(() {
                                      _tappedIndex = index;
                                    }),
                                    onTapUp: (_) => setState(() {
                                      _tappedIndex = null;
                                    }),
                                    onTapCancel: () => setState(() {
                                      _tappedIndex = null;
                                    }),
                                    onTap: () async {
                                      final bloc =
                                          context.read<VocabularyBloc>();
                                      final updated = word.copyWith(
                                          addedToFavoriteAt: DateTime.now());
                                      bloc.add(VocabularyEvent.changeStatus(
                                          updated, 'favorite'));
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              WordDetailsScreen(word: updated),
                                        ),
                                      );
                                    },
                                    child: AnimatedScale(
                                      scale: _tappedIndex == index ? 0.97 : 1.0,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE3F2FD),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueAccent
                                                  .withOpacity(0.08),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(Icons.favorite,
                                              color: Colors.pinkAccent),
                                          title: Text(
                                            word.word,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                word.pos,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: _getPosColor(word.pos),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                icon: const Icon(Icons.close,
                                                    color: Colors.red),
                                                tooltip: 'Xóa khỏi yêu thích',
                                                onPressed: () {
                                                  final bloc = context
                                                      .read<VocabularyBloc>();
                                                  final updated = word.copyWith(
                                                      userDefinition: null,
                                                      addedToFavoriteAt: null);
                                                  bloc.add(VocabularyEvent
                                                      .changeStatus(
                                                          updated, null));
                                                  bloc.add(const VocabularyEvent
                                                      .getAllOxfordWords());
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bạn chưa có từ vựng yêu thích nào. Hãy nhấn vào biểu tượng trái tim để lưu từ mới nhé!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Image.asset(
                                'assets/images/b721d352-54cc-40dc-949c-7382f9bee707.gif',
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ).animate().fadeIn(duration: 600.ms)
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPosColor(String pos) {
    final p = pos.toLowerCase();
    if (p.contains('noun')) return Colors.amber[800]!;
    if (p.contains('verb')) return Colors.red;
    if (p.contains('adjective')) return Colors.purple;
    if (p.contains('adverb')) return Colors.blue;
    if (p.contains('preposition')) return Colors.green;
    if (p.contains('pronoun')) return Colors.orange;
    if (p.contains('conjunction')) return Colors.teal;
    if (p.contains('interjection')) return Colors.pink;
    if (p.contains('auxiliary')) return Colors.indigo;
    if (p.contains('determiner')) return Colors.brown;
    if (p.contains('number')) return Colors.grey;
    if (p.contains('exclamation')) return Colors.cyan;
    if (p.contains('modal verb')) return Colors.indigo;
    if (p.contains('ordinal number')) return Colors.brown;
    if (p.contains('linking verb')) return Colors.lime;
    if (p.contains('definite article')) return Colors.deepOrange;
    if (p.contains('infinitive marker')) return Colors.deepPurple;

    return Colors.blueGrey;
  }
}
