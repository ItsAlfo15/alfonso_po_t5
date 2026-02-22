import 'package:alfonso_po_t5/pages/brand_watches_page.dart';
import 'package:alfonso_po_t5/pages/home_page.dart';
import 'package:alfonso_po_t5/pages/login_page.dart';
import 'package:alfonso_po_t5/pages/register_page.dart';
import 'package:alfonso_po_t5/pages/splash_screen.dart';
import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WatchProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => LoginFormProvider(), lazy: false),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luxury Watch Catalog',
      home: const SplashScreen(),
      routes: {
        'home': (_) => const HomePage(),
        'register': (_) => const RegisterPage(),
        'login': (_) => const LoginPage(),
        'brand_watches': (_) => const BrandWatchesPage(),
      },

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFD4AF37),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111111),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
        ),

        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF161616)),

        cardColor: const Color(0xFF1C1C1C),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
