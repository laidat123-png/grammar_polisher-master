import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:lottie/lottie.dart';
import '../../../generated/assets.dart';

import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/streak_bloc.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  int? _lastStreak;
  bool _showConfetti = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<StreakBloc>().state;
    _lastStreak ??= state.streak;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    // Giả sử có biến userName, nếu không có thì để null
    final String? userName = null;
    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        final percent = state.spentTimeToday / StreakBloc.timePerDayNeeded;
        // Hiệu ứng confetti khi chuỗi tăng lên
        if (_lastStreak != null && state.streak > _lastStreak!) {
          _showConfetti = true;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _showConfetti = false);
          });
        }
        _lastStreak = state.streak;
        // Huy hiệu
        List<Widget> badges = [];
        if (state.streak >= 3) {
          badges.add(_buildBadge('3 ngày'));
        }
        if (state.streak >= 7) {
          badges.add(_buildBadge('7 ngày'));
        }
        if (state.streak >= 30) {
          badges.add(_buildBadge('30 ngày'));
        }
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFDEB71),
                    Color(0xFFF8D800),
                    Color(0xFFF1C40F)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: BasePage(
                    title: "Chuỗi Học",
                    actions: [],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.shortestSide * 0.4,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: size.shortestSide * 0.2,
                                lineWidth: 10.0,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: percent > 1 ? 1 : percent,
                                center: state.streak != 0
                                    ? Image.asset(Assets.pngFlame, width: 64)
                                    : Image.asset(Assets.pngFlameInactive,
                                        width: 64),
                                progressColor: Color(0xFFf5a623),
                              ),
                              if (badges.isNotEmpty)
                                Positioned(
                                  bottom: 0,
                                  child: Row(children: badges),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          state.streak.toString(),
                          style: textTheme.headlineLarge?.copyWith(
                            color: state.streak != 0
                                ? Color(0xFFf5a623)
                                : colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Chuỗi",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          userName != null
                              ? "Tiếp tục phát huy nhé, $userName!"
                              : "Tiếp tục phát huy nhé!",
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          "Học ít nhất 5 phút mỗi ngày để duy trì chuỗi học! Những bước nhỏ sẽ dẫn đến kết quả lớn. 🚀",
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                BannerAdWidget()
              ],
            ),
            if (_showConfetti)
              Center(
                child: Lottie.asset(
                  Assets.lottieConfetti,
                  repeat: false,
                  width: 250,
                  height: 250,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
