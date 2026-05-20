import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/widgets/auth/login_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reseteamos el estado del formulario al entrar en la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginFormProvider>().resetForm();
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / cabecera
              Image.asset(  
                'assets/images/logo.png',
                width: 90,
                height: 90,
              ),
              const SizedBox(height: 20),
              const Text(
                'LUXWATCH',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 40),

              // Tarjeta de login — usa el provider global
              const LoginCard(),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                child: const Text(
                  '¿Sin cuenta? Regístrate aquí',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}