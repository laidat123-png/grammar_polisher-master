import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'configs/di.dart';
import 'data/repositories/oxford_words_repository.dart';
import 'navigation/app_router.dart';
import 'ui/blocs/translate/translate_cubit.dart';
import 'ui/screens/settings/bloc/settings_bloc.dart';
import 'utils/ad/consent_manager.dart';
import 'utils/global_values.dart';
import 'utils/local_notifications_tools.dart';
import 'ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import 'ui/screens/notifications/bloc/notifications_bloc.dart';
import 'ui/screens/grammar/bloc/lesson_bloc.dart';
import 'ui/screens/streak/bloc/streak_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final brightness = SchedulerBinding.instance.window.platformBrightness;
  final isDarkMode = brightness == Brightness.dark;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ),
  );
  await Firebase.initializeApp();
  await Future.wait([
    MobileAds.instance.initialize(),
    LocalNotificationsTools().initialize(
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    ),
    DI().init(),
    GlobalValues.init(),
  ]);
  ConsentManager.gatherConsent((consentError) {
    if (consentError != null) {
      debugPrint(
          "Consent error: ${consentError.errorCode}: ${consentError.message}");
    }
    MobileAds.instance.initialize();
  });
  await DI().sl<OxfordWordsRepository>().initData();

  debugPrint('setAnalyticsCollectionEnabled true');
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebaseAnalytics.instance.setConsent(
    analyticsStorageConsentGranted: true,
    adPersonalizationSignalsConsentGranted: true,
    adStorageConsentGranted: true,
    adUserDataConsentGranted: true,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  tz.initializeTimeZones();
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  // Kiểm tra trạng thái đăng nhập và onboarding
  final prefs = await SharedPreferences.getInstance();
  final isShowOnboarding = prefs.getBool('isShowOnboarding') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final initialLocation = !isShowOnboarding
      ? '/onboarding'
      : (isLoggedIn ? '/vocabulary' : '/login');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DI().sl<SettingsBloc>()),
        BlocProvider(create: (context) => DI().sl<TranslateCubit>()),
        BlocProvider(create: (context) => DI().sl<VocabularyBloc>()),
        BlocProvider(create: (context) => DI().sl<NotificationsBloc>()),
        BlocProvider(create: (context) => DI().sl<LessonBloc>()),
        BlocProvider(create: (context) => DI().sl<StreakBloc>()),
      ],
      child: App(initialLocation: initialLocation),
    ),
  );
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  debugPrint(
      'onDidReceiveNotificationResponse: ${notificationResponse.payload}');
  final id = int.tryParse(notificationResponse.payload ?? '');
  AppRouter.rootNavigatorKey.currentContext
      ?.go(RoutePaths.vocabulary, extra: {'wordId': id});
}

void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) {
  debugPrint(
      'onDidReceiveBackgroundNotificationResponse: ${notificationResponse.payload}');
  final id = int.tryParse(notificationResponse.payload ?? '');
  AppRouter.rootNavigatorKey.currentContext
      ?.go(RoutePaths.vocabulary, extra: {'wordId': id});
}
