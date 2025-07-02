import 'package:flutter/material.dart';
import 'svg_button.dart';
import '../../generated/assets.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final String title;
  final EdgeInsets padding;
  final List<Widget> actions;

  const BasePage({
    super.key,
    required this.child,
    required this.title,
    this.actions = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: kToolbarHeight + 4.0,
            leadingWidth: 70.0,
            leading: Navigator.of(context).canPop()
                ? SvgButton(
                    svg: Assets.svgArrowBackIos,
                    color: colorScheme.primary,
                    onPressed: () => Navigator.of(context).pop(),
                    size: 20.0,
                  )
                : null,
            title: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorScheme.primary,
              ),
            ),
            actions: actions,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Container(
                color: colorScheme.surface,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
