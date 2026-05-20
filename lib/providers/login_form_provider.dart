import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class LoginFormProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final _urlBase = 'https://backend-relojes-mejorado.onrender.com/api/v1';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? currentUser;

  // Funcion que resetea el formulario y el estado del provider (para evitar que al cerrar sesion queden datos anteriores)
  void resetForm() {
    email = '';
    password = '';
    errorMessage = null;
    _isLoading = false;
    formKey = GlobalKey<FormState>();
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<bool> autoLogin() async {
    final token = await storage.read(key: 'access_token');
    final userJson = await storage.read(key: 'user_data');

    if (token == null || userJson == null) return false;

    try {
      currentUser = jsonDecode(userJson);
      notifyListeners();

      final response = await get(
        Uri.parse('$_urlBase/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) return true;
      
      if (response.statusCode == 401) await logout();
    } catch (_) {
      return currentUser != null;
    }
    return false;
  }

  Future<void> loadUserFromStorage() async {
    final userJson = await storage.read(key: 'user_data');
    if (userJson != null) {
      currentUser = jsonDecode(userJson);
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    currentUser = null;
    errorMessage = null;

    await storage.delete(key: 'access_token');
    await storage.delete(key: 'user_data');

    final uri = Uri.parse('$_urlBase/user/login');
    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final accessToken = decodedData['data']['accesstoken'];
      final user = decodedData['data']['user'];

      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'user_data', value: jsonEncode(user));

      currentUser = user;
      notifyListeners();
      return accessToken;
    }

    final message = decodedData['data']?['error']?['message'] ??
        decodedData['message'] ??
        'Error desconocido';
    throw Exception(message);
  }

  Future<void> logout() async {
    currentUser = null;
    errorMessage = null;
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'user_data');
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}