import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:grammar_polisher/utils/quiz_state_manager.dart';
import 'package:grammar_polisher/utils/navigation_notification.dart' as custom;

import '../../../core/failure.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../streak/bloc/streak_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widget/streak_button.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell child;

  const HomeNavigation({super.key, required this.child});

  static const routes = [
    RoutePaths.vocabulary,
    RoutePaths.grammar,
    RoutePaths.quiz,
    RoutePaths.streak,
    RoutePaths.settings,
  ];

  static const icons = [
    Assets.svgVocabulary,
    Assets.svgGrammar,
    Assets.svgCheck,
    Assets.svgStreak,
    Assets.svgSettings,
  ];

  static const labels = [
    "Tra từ",
    "Ngữ Pháp",
    "Luyện tập",
    "Chuỗi",
    "Cài Đặt",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  late final AppLifecycleListener _appLifecycleListener;
  // Giả lập trạng thái đăng nhập và streak
  final bool isLoggedIn = true;
  final String? avatarUrl = null;
  final int streak = 5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentRoute = GoRouter.of(context).currentRoute;
    var selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    final selectedColor = colorScheme.primary;
    final unselectedColor = Colors.grey[600]!;

    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            _handleError(context, state.failure);
            if (state.wordIdFromNotification != null) {
              context.go(RoutePaths.vocabulary,
                  extra: {'wordId': state.wordIdFromNotification});
            }
            if (state.message != null) {
              AppSnackBar.showSuccess(context, state.message!);
            }
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: [0, 1].contains(widget.child.currentIndex) &&
                HomeNavigation.routes.contains(
                    widget.child.shellRouteContext.routerState.uri.path)
            ? StreakButton(
                onPressed: () {
                  widget.child.goBranch(
                      HomeNavigation.routes.indexOf(RoutePaths.streak));
                },
              )
            : null,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: widget.child),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              currentIndex: widget.child.currentIndex,
              onTap: (index) async {
                final quizStateManager = QuizStateManager();
                if (quizStateManager.isQuizInProgressNotifier.value) {
                  // Hiện dialog xác nhận ngay tại đây
                  final shouldExit = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Thoát bài luyện tập'),
                      content: const Text(
                          'Bạn có chắc chắn muốn thoát? Tiến trình của bạn sẽ bị mất.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Không'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Có'),
                        ),
                      ],
                    ),
                  );
                  if (shouldExit == true) {
                    quizStateManager.setQuizInProgress(false);
                    widget.child.goBranch(index);
                  }
                } else {
                  widget.child.goBranch(index);
                }
              },
              selectedFontSize: 12,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              items: List.generate(
                HomeNavigation.labels.length,
                (index) {
                  Widget iconWidget;
                  // Tab Cài Đặt: avatar nếu đã đăng nhập
                  if (index == 4 && isLoggedIn) {
                    iconWidget = CircleAvatar(
                      radius: 14,
                      backgroundColor: index == selectedIndex
                          ? colorScheme.primaryContainer
                          : Colors.transparent,
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? Icon(Icons.person, color: selectedColor, size: 18)
                          : null,
                    );
                  } else {
                    iconWidget = SvgPicture.asset(
                      HomeNavigation.icons[index],
                      colorFilter: ColorFilter.mode(
                        index == selectedIndex
                            ? selectedColor
                            : unselectedColor,
                        BlendMode.srcIn,
                      ),
                      height: 24,
                    );
                  }
                  // Badge cho tab Chuỗi
                  Widget badgeIcon = iconWidget;
                  if (index == 3 && streak > 0) {
                    badgeIcon = Stack(
                      clipBehavior: Clip.none,
                      children: [
                        iconWidget,
                      ],
                    );
                  }
                  return BottomNavigationBarItem(
                    icon: AnimatedScale(
                      scale: index == selectedIndex ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedOpacity(
                        opacity: index == selectedIndex ? 1.0 : 0.7,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: badgeIcon,
                        ),
                      ),
                    ),
                    label: HomeNavigation.labels[index],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.add(const NotificationsEvent.requestPermissions());
    notificationsBloc
        .add(const NotificationsEvent.handleOpenAppFromNotification());

    // Đảm bảo StreakBloc chỉ được khởi tạo một lần và được hủy đúng cách
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StreakBloc>().add(const StreakEvent.watchStreak());
      }
    });

    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // this is needed to update the permissions status when the user returns to the app after changing the notification settings
        if (mounted) {
          notificationsBloc.add(const NotificationsEvent.requestPermissions());
        }
      },
    );
  }

  @override
  void dispose() {
    _appLifecycleListener?.dispose();
    super.dispose();
  }

  _handleError(BuildContext context, Failure? failure) {
    if (failure != null) {
      AppSnackBar.showError(context, failure.message);
    }
  }

  void _onSelect(int index) {
    debugPrint('HomeNavigationScreen -> onTap -> index: $index');
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex,
    );
  }
}
