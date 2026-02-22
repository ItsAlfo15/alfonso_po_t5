import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class RegisterFormProvider extends ChangeNotifier {
  final _urlBase = 'https://backend-relojes-mejorado.onrender.com/api/v1';

  // Key que se va a usar para referenciar al formulario de logueo
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String? errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    Uri uri = Uri.parse('$_urlBase/user/register');

    Response response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(decodedData['data']['error']['message']);
    }
  }

  bool isValidForm() {
    // print(formKey.currentState?.validate());
    // print('Email: $email');
    // print('Password: $password');
    return formKey.currentState?.validate() ?? false;
  }
}
