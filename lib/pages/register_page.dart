import 'package:alfonso_po_t5/providers/register_form.dart';
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
              ChangeNotifierProvider(
                create: (_) => RegisterFormProvider(),
                child: RegisterCard(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
