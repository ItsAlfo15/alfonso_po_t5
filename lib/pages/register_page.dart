import 'package:alfonso_po_t5/providers/register_form_provider.dart';
import 'package:alfonso_po_t5/widgets/register_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              ChangeNotifierProvider(
                create: (_) => RegisterFormProvider(),
                child: RegisterCard(),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: Text(
                  'Volver al inicio se sesión',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
