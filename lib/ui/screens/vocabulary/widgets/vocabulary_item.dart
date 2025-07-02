import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/custom_colors.dart';
import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/svg_button.dart';
import '../bloc/vocabulary_bloc.dart';
import 'phonetic.dart';
import 'pos_badge.dart';

class VocabularyItem extends StatelessWidget {
  final Word word;
  final bool viewOnly;
  final VoidCallback? onMastered;
  final VoidCallback? onReminder;

  const VocabularyItem({
    super.key,
    required this.word,
    this.viewOnly = false,
    this.onMastered,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pos = word.pos.split(', ');
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () => _openWordDetails(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row: Word and PosBadges
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: SelectableText(
                      word.word,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 4, // Spacing between badges
                    children: List.generate(
                      pos.length,
                      (index) => PosBadge(pos: pos[index]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Space between first and second row
              // Second Row: Definition
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((word.senses.isNotEmpty ||
                            word.userDefinition != null))
                          Text(
                            word.userDefinition != null &&
                                    word.userDefinition != 'favorite'
                                ? "${word.userDefinition} (edited)"
                                : word.senses.first.definition,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openWordDetails(BuildContext context) {
    if (viewOnly) {
      return;
    }
    context.push(RoutePaths.wordDetails, extra: {'word': word});
  }
}
