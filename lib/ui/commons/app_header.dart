import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
