import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegisterFormProvider extends ChangeNotifier {
  final _urlBase = 'https://backend-relojes-mejorado.onrender.com/api/v1';

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

  void resetForm() {
    name = '';
    email = '';
    password = '';
    errorMessage = null;
    _isLoading = false;
    formKey = GlobalKey<FormState>();
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    final uri = Uri.parse('$_urlBase/user/register');

    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 201) return true;

    throw Exception(decodedData['data']?['error']?['message'] ??
        decodedData['message'] ??
        'Error al registrar');
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}