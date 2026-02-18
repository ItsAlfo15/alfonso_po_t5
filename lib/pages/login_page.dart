import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/widgets/login_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: LoginCard(),
              ),
              SizedBox(height: 50),
              Text(
                '¿Todavía sin cuenta? Crea una ahora',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
