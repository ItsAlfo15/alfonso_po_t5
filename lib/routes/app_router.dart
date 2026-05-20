import 'package:alfonso_po_t5/pages/brand_watches_page.dart';
import 'package:alfonso_po_t5/pages/home_page.dart';
import 'package:alfonso_po_t5/pages/login_page.dart';
import 'package:alfonso_po_t5/pages/onboarding_page.dart';
import 'package:alfonso_po_t5/pages/register_page.dart';
import 'package:alfonso_po_t5/pages/splash_screen.dart';
import 'package:alfonso_po_t5/pages/watch_detail_page.dart';
import 'package:flutter/material.dart';

/// Clase estática de rutas de la aplicación.
/// Alternativa centralizada a la definición de rutas en MaterialApp.
class AppRouter {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String brandWatches = 'brand_watches';
  static const String watchDetail = 'watch_detail';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingPage(),
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        home: (_) => const HomePage(),
        brandWatches: (_) => const BrandWatchesPage(),
        watchDetail: (_) => const WatchDetailPage(),
      };
}