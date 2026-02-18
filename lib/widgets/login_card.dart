import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 88, 88),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Login', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 30),
            _LoginForm(),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupero la info del provider
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        // Activo el modo de autovalidacion del formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: loginFormProvider.formKey,
        child: Column(
          children: [

            // CORREO
            TextFormField(
              autocorrect: false,
              onChanged: (value) => loginFormProvider.email = value,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Introduce tu correo',
                labelText: 'Correo',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              validator: (value) {
                // Regexp para validar correos
                String patterm =
                    r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = RegExp(patterm);

                if (value == null || value.isEmpty) {
                  return 'Debes rellenar este campo';
                }

                return regExp.hasMatch(value) ? null : 'El correo no es válido';
              },
            ),
            SizedBox(height: 15),

            // CONTRASEÑA
            TextFormField(
              autocorrect: false,
              onChanged: (value) => loginFormProvider.password = value,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Introduce tu contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.remove_red_eye,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar este campo';
                } else if (value.length < 8) {
                  return 'Contraseña no válida';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromARGB(255, 184, 163, 5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text('Entrar', style: TextStyle(color: Colors.white)),
              ),
              onPressed: () {
                if (!loginFormProvider.isValidForm()) return;
                Navigator.pushReplacementNamed(context, 'home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
