import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'cupertino_back_button.dart'; // chứa ShadowButton

class CustomAppBar extends StatelessWidget {
  final String? title;
  final List<Widget> actions;

  const CustomAppBar({super.key, this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canPop = context.canPop();

    return Container(
      height: 56, // chuẩn material toolbar height
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button bên trái
          if (canPop)
            Align(
              alignment: Alignment.centerLeft,
              child: ShadowButton(
                onPress: () {
                  context.pop();
                },
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 15), // 👈 icon nhỏ lại
              ),
            ),

          // Tiêu đề ở giữa
          if (title != null)
            Center(
              child: Text(
                title!,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.secondary.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Actions bên phải
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}
