import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'constants/app_strings.dart';
import 'theme/app_theme.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/request_screen.dart';
import 'screens/requests_tab_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/skill_listing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SkillSwapApp());
}

/// ---------------- THEME CONTROLLER ----------------
/// This controls light/dark mode globally
class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  static void toggle(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,

          themeMode: mode,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),

          initialRoute: AppStrings.splash,
          routes: {
            AppStrings.splash: (_) => const SplashScreen(),
            AppStrings.onboarding: (_) => const OnboardingScreen(),
            AppStrings.login: (_) => const LoginScreen(),
            AppStrings.signup: (_) => const SignupScreen(),
            AppStrings.home: (_) => const HomeScreen(),
            AppStrings.explore: (_) => const ExploreScreen(),
            AppStrings.skillListing: (_) => const SkillListingScreen(),
            AppStrings.profile: (_) => const ProfileScreen(),
            AppStrings.request: (_) => const RequestScreen(),
            AppStrings.chat: (_) => const ChatScreen(),
            AppStrings.requestsTab: (_) => const RequestsTabScreen(),
            AppStrings.settings: (_) => const SettingsScreen(),
          },
        );
      },
    );
  }
}