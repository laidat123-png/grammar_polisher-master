import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/category_data.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/animated_progress_bar.dart';

class HomeItem extends StatelessWidget {
  final CategoryData category;

  const HomeItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    IconData icon;
    switch (category.title.toLowerCase()) {
      case 'các thì':
        icon = Icons.access_time;
        break;
      case 'các câu':
        icon = Icons.format_quote;
        break;
      case 'các từ loại':
        icon = Icons.category;
        break;
      case 'others':
        icon = Icons.more_horiz;
        break;
      default:
        icon = Icons.book;
    }
    final isCompleted = category.progress == category.total;
    return GestureDetector(
      onTap: () => _onTap(context),
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colorScheme.primary, size: 28),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.title,
                            style: textTheme.titleMedium?.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCompleted)
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      category.description,
                      style: textTheme.bodyMedium?.copyWith(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: colorScheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    _AnimatedGradientProgressBar(
                        value: category.progress / category.total),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.push(RoutePaths.category, extra: {'category': category});
  }
}

class _AnimatedGradientProgressBar extends StatelessWidget {
  final double value;
  const _AnimatedGradientProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, val, child) {
        return Container(
          height: 22,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 22,
                width:
                    (val.clamp(0, 1)) * MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '${(val * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
