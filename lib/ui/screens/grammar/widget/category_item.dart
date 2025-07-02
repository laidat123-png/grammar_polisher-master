import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/lesson.dart';
import '../../../../generated/assets.dart';
import '../bloc/lesson_bloc.dart';

class CategoryItem extends StatelessWidget {
  final bool hasAds;
  final Lesson lesson;
  final Function(bool?) onMark;
  final bool isBeta;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.lesson,
    required this.onMark,
    this.hasAds = false,
    this.isBeta = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        final isMarked = state.markedLessons[lesson.id] ?? false;

        return SizedBox(
          width: double.infinity, // ✅ ép full width như khung search
          child: MaterialButton(
            elevation: 0.0,
            padding: const EdgeInsets.all(12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: isMarked
                ? colorScheme.secondaryContainer
                : colorScheme.primaryContainer,
            onPressed: isBeta ? null : onTap,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // ✅ chữ trái - checkbox phải
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // ✅ căn trái nội dung
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              lesson.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                decoration: isMarked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isMarked
                                    ? colorScheme.onSecondaryContainer
                                    : colorScheme.onPrimaryContainer
                                        .withOpacity(
                                        isBeta ? 0.5 : 1,
                                      ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          if (hasAds)
                            SvgPicture.asset(
                              Assets.svgTimerPlay,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                colorScheme.onPrimaryContainer,
                                BlendMode.srcIn,
                              ),
                            ),
                        ],
                      ),
                      if (lesson.subTitle != null)
                        Text(
                          lesson.subTitle!,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 22,
                            decoration:
                                isMarked ? TextDecoration.lineThrough : null,
                            color: isMarked
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onPrimaryContainer.withOpacity(
                                    isBeta ? 0.5 : 1,
                                  ),
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  value: isMarked,
                  onChanged: isBeta ? null : onMark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
