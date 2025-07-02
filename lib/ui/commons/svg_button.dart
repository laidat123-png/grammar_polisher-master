import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  final String svg;
  final double size;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const SvgButton({
    super.key,
    required this.svg,
    this.onPressed,
    this.size = 20,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        child: Container(
          width: size, // 👈 Giới hạn kích thước khung chứa
          height: size,
          padding: padding == EdgeInsets.zero
              ? const EdgeInsets.all(4) // 👈 Ít padding mặc định
              : padding,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            svg,
            height: size,
            width: size,
            colorFilter: ColorFilter.mode(
              color ?? colorScheme.onPrimaryContainer,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
