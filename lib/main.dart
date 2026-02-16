import 'package:alfonso_po_t5/pages/home_page.dart';
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
      title: 'App Relojes',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
      },
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Colors.black,)
      )
    );
  }
}