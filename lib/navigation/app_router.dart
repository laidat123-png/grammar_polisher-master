import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/utils/global_values.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../configs/di.dart';
import '../data/models/category_data.dart';
import '../data/models/lesson.dart';
import '../data/models/word.dart';
import '../ui/screens/grammar/bloc/lesson_bloc.dart';
import '../ui/screens/grammar/category_screen.dart';
import '../ui/screens/grammar/lesson_screen.dart';
import '../ui/screens/grammar/grammar_screen.dart';
import '../ui/screens/home_navigation/home_navigation.dart';
import '../ui/screens/notifications/bloc/notifications_bloc.dart';
import '../ui/screens/onboaring/onboarding_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/streak/bloc/streak_bloc.dart';
import '../ui/screens/streak/streak_screen.dart';
import '../ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import '../ui/screens/vocabulary/vocabulary_screen.dart';
import '../ui/screens/vocabulary/word_details_screen.dart';
import '../ui/screens/quiz/simple_present_quiz_screen.dart';
import '../ui/screens/quiz/quiz_result_screen.dart';
import '../ui/screens/quiz/quiz_selection_screen.dart';
import '../screen/LoginEnglish.dart';
import '../screen/RegisterEnglish.dart';
import '../screen/QuenmatkhauEnglish.dart';
import '../ui/screens/vocabulary/saved_words_screen.dart';
import '../ui/screens/vocabulary/search_history_screen.dart';
import '../ui/screens/quiz/vietnamese_to_english_quiz_screen.dart';
import '../ui/screens/quiz/past_simple_quiz_screen.dart';
import '../ui/screens/quiz/present_continuous_quiz_screen.dart';
import '../ui/screens/quiz/present_perfect_quiz_screen.dart';
import '../ui/screens/quiz/present_perfect_continuous_quiz_screen.dart';
import '../ui/screens/quiz/past_continuous_quiz_screen.dart';
import '../ui/screens/quiz/past_perfect_quiz_screen.dart';
import '../ui/screens/quiz/past_perfect_continuous_quiz_screen.dart';
import '../ui/screens/quiz/future_simple_quiz_screen.dart';
import '../ui/screens/quiz/future_continuous_quiz_screen.dart';
import '../ui/screens/quiz/future_perfect_quiz_screen.dart';
import '../ui/screens/quiz/future_perfect_continuous_quiz_screen.dart';
import '../ui/screens/quiz/near_future_quiz_screen.dart';
import '../ui/screens/terms_of_use/terms_of_use_screen.dart';

part 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter getRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      navigatorKey: rootNavigatorKey,
      redirect: (context, state) {
        if (!GlobalValues.isShowOnboarding) {
          GlobalValues.isShowOnboarding = true;
          return RoutePaths.onboarding;
        }
        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shellRoutes) {
            return HomeNavigation(
              child: shellRoutes,
            );
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutePaths.vocabulary,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final wordId = extra?['wordId'] as int?;
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: VocabularyScreen(wordId: wordId),
                  );
                },
              ),
              GoRoute(
                path: RoutePaths.wordDetails,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final word = extra?['word'] as Word;
                  return SwipeablePage(
                    key: state.pageKey,
                    builder: (context) => WordDetailsScreen(word: word),
                  );
                },
              ),
              GoRoute(
                path: RoutePaths.savedWords,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const SavedWordsScreen(),
                  );
                },
              ),
              GoRoute(
                path: RoutePaths.searchHistory,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const SearchHistoryScreen(),
                  );
                },
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutePaths.grammar,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: GrammarScreen(),
                  );
                },
              ),
              GoRoute(
                path: RoutePaths.category,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final category = extra?['category'] as CategoryData;
                  return SwipeablePage(
                    key: state.pageKey,
                    builder: (context) => CategoryScreen(
                      category: category,
                    ),
                  );
                },
              ),
              GoRoute(
                path: RoutePaths.lesson,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final lesson = extra?['lesson'] as Lesson;
                  return SwipeablePage(
                    key: state.pageKey,
                    builder: (context) => LessonScreen(
                      lesson: lesson,
                    ),
                  );
                },
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutePaths.quiz,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const QuizSelectionScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'simple_present_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const SimplePresentQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'vietnamese_to_english_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const VietnameseToEnglishQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'past_simple_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PastSimpleQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'present_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PresentContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'present_perfect_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PresentPerfectQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'present_perfect_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PresentPerfectContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'past_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PastContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'past_perfect_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PastPerfectQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'past_perfect_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const PastPerfectContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'future_simple_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const FutureSimpleQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'future_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const FutureContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'future_perfect_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const FuturePerfectQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'future_perfect_continuous_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const FuturePerfectContinuousQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'near_future_quiz',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const NearFutureQuizScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'quiz_result',
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      if (extra == null)
                        return NoTransitionPage(
                          key: state.pageKey,
                          child: const QuizSelectionScreen(),
                        );

                      final score = extra['score'] as int? ?? 0;
                      final totalQuestions =
                          extra['totalQuestions'] as int? ?? 0;
                      final quizDuration =
                          extra['quizDuration'] as Duration? ?? Duration.zero;
                      final userAnswers = (extra['userAnswers'] as List?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          <String>[];
                      final quizKey = extra['quizKey'] as String?;
                      final questionDetails = extra['questionDetails'];

                      return NoTransitionPage(
                        key: state.pageKey,
                        child: QuizResultScreen(
                          score: score,
                          totalQuestions: totalQuestions,
                          quizDuration: quizDuration,
                          userAnswers: userAnswers,
                          quizKey: quizKey,
                          questionDetails: questionDetails,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutePaths.streak,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const StreakScreen(),
                  );
                },
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutePaths.settings,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
            ]),
          ],
        ),
        GoRoute(
          path: RoutePaths.login,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const LoginEnglish(),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.register,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const RegisterEnglish(),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const QuenmatkhauEnglish(),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.onboarding,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const OnboardingScreen(),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.termsOfUse,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const TermsOfUseScreen(),
            );
          },
        ),
      ],
    );
  }
}
