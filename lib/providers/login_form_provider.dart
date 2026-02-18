import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  // Key que se va a usar para referenciar al formulario de logueo
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  
  set isLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  bool isValidForm() {
    // print(formKey.currentState?.validate());
    // print('Email: $email');
    // print('Password: $password');
    return formKey.currentState?.validate() ?? false;
  }
}