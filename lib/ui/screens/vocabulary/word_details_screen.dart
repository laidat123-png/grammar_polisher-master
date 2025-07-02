import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/custom_colors.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/selection_area_with_search.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/phonetic.dart';
import '../../../data/data_sources/search_history_data.dart';
import '../../../data/models/search_history_item.dart';

class WordDetailsScreen extends StatefulWidget {
  final Word word;

  const WordDetailsScreen({super.key, required this.word});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.word.userDefinition == 'favorite';
    _saveToSearchHistory();
  }

  void _saveToSearchHistory() async {
    await SearchHistoryData().addHistory(
      SearchHistoryItem(
          word: widget.word.word,
          pos: widget.word.pos,
          searchedAt: DateTime.now()),
    );
  }

  void _onToggleFavorite(BuildContext context) {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(
        widget.word, _isFavorite ? 'favorite' : null));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Set<String> allSynonyms = {};
    final Set<String> allAntonyms = {};

    for (var sense in widget.word.senses) {
      allSynonyms.addAll(sense.synonyms);
      allAntonyms.addAll(sense.antonyms);
    }

    return SelectionAreaWithSearch(
      child: BasePage(
        title: widget.word.word,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? CustomColors.red : null,
            ),
            onPressed: () => _onToggleFavorite(context),
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.word.word,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Phonetic(
                    phonetic: widget.word.phonetic,
                    phoneticText: widget.word.phoneticText,
                    backgroundColor: CustomColors.green,
                  ),
                  const SizedBox(width: 8),
                  Phonetic(
                    phonetic: widget.word.phoneticAm,
                    phoneticText: widget.word.phoneticAmText,
                    backgroundColor: CustomColors.red,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildSectionTitle(context, "Loại từ: ${widget.word.pos}"),
              const SizedBox(height: 8),
              BannerAdWidget(
                paddingVertical: 8,
                paddingHorizontal: 0,
              ),
              _buildSectionTitle(context, "Định nghĩa"),
              const SizedBox(height: 8),
              ...List.generate(widget.word.senses.length, (index) {
                final sense = widget.word.senses[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${sense.definition}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (sense.vi.isNotEmpty)
                      Text(
                        'Tiếng Việt: ${sense.vi}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (sense.examples.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text("Ví dụ:"),
                      ...List.generate(
                        sense.examples.length,
                        (exampleIndex) {
                          final example = sense.examples[exampleIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${exampleIndex + 1}. ${example.x}',
                                style: textTheme.bodyMedium,
                              ),
                              if (example.vi.isNotEmpty)
                                Text(
                                  'Tiếng Việt: ${example.vi}', // <-- Đã thêm lại tiền tố
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                );
              }),
              if (allSynonyms.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(context, "Từ đồng nghĩa"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: allSynonyms
                      .map((synonym) => _buildChip(context, synonym))
                      .toList(),
                ),
              ],
              if (allAntonyms.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(context, "Từ trái nghĩa"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: allAntonyms
                      .map((antonym) => _buildChip(context, antonym))
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(text),
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
    );
  }
}
