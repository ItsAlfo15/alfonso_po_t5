import 'package:alfonso_po_t5/providers/register_form_provider.dart';
import 'package:alfonso_po_t5/widgets/auth/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterCard extends StatelessWidget {
  const RegisterCard({super.key});

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
            Text(
              'Formulario de Registro',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 30),
            _RegisterForm(),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupero la info del provider
    final registerFormProvider = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        // Activo el modo de autovalidacion del formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: registerFormProvider.formKey,
        child: Column(
          children: [
            // NOMBRE
            TextFormField(
              autocorrect: false,
              onChanged: (value) => registerFormProvider.name = value,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Introduce tu nombre',
                labelText: 'Nombre',
                prefixIcon: Icons.person_2,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar este campo';
                }
                return null;
              },
            ),
            SizedBox(height: 15),

            // CORREO
            TextFormField(
              autocorrect: false,
              onChanged: (value) => registerFormProvider.email = value,
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
              onChanged: (value) => registerFormProvider.password = value,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Introduce tu contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.remove_red_eye,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debes rellenar este campo';
                } else if (value.length < 8) {
                  return 'Mínimo 8 caracteres.';
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
              onPressed: registerFormProvider.isLoading
                  ? null
                  : () async {
                      if (!registerFormProvider.isValidForm()) return;

                      registerFormProvider.isLoading = true;
                      registerFormProvider.setError = null;

                      try {
                        final registerComplete = await registerFormProvider
                            .register(
                              registerFormProvider.name,
                              registerFormProvider.email,
                              registerFormProvider.password,
                            );

                        if (registerComplete) {
                          await Future.delayed(
                            const Duration(milliseconds: 1500),
                          );
                          Navigator.pushReplacementNamed(context, 'login');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡Usuario registrado con éxito!, logueate a continuación.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                114,
                                212,
                                107,
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } catch (error) {
                        String errorMessage = error is Exception
                            ? error.toString().replaceFirst('Exception: ', '')
                            : error.toString();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              187,
                              89,
                              82,
                            ),
                            duration: Duration(seconds: 3),
                            
                          ),
                        );
                      } finally {
                        registerFormProvider.isLoading = false;
                      }
                    },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: registerFormProvider.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
