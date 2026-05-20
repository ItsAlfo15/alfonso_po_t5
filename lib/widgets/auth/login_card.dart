import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/widgets/auth/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 88, 88),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text('Login', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 30),
            const _LoginForm(),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: loginFormProvider.formKey,
      child: Column(
        children: [
          // Correo
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
              const pattern =
                  r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              if (value == null || value.isEmpty) {
                return 'Debes rellenar este campo';
              }
              return RegExp(pattern).hasMatch(value)
                  ? null
                  : 'El correo no es válido';
            },
          ),
          const SizedBox(height: 15),

          // Contraseña
          TextFormField(
            autocorrect: false,
            onChanged: (value) => loginFormProvider.password = value,
            obscureText: obscurePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Introduce tu contraseña',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ).copyWith(
              // Icono que alterna al pulsar
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white54,
                ),
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
              ),
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
          const SizedBox(height: 15),

          // Boton de entrar
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color.fromARGB(255, 184, 163, 5),
            onPressed: loginFormProvider.isLoading
                ? null
                : () async {
                    if (!loginFormProvider.isValidForm()) return;

                    loginFormProvider.isLoading = true;
                    loginFormProvider.setError = null;

                    try {
                      await loginFormProvider.login(
                        loginFormProvider.email,
                        loginFormProvider.password,
                      );
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, 'home');
                      }
                    } catch (error) {
                      final msg = error
                          .toString()
                          .replaceFirst('Exception: ', '');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              msg,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 187, 89, 82),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    } finally {
                      if (context.mounted) {
                        loginFormProvider.isLoading = false;
                      }
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: loginFormProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
