import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loginProvider = context.read<LoginFormProvider>();

    final loggedIn = await loginProvider.autoLogin();

    if (!mounted) return;

    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
