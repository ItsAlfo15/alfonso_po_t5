import 'dart:convert';

import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WatchProvider extends ChangeNotifier {
  final String _urlBase = 'https://alfonso-backend-relojes.onrender.com';

  List<Reloj> watches = [];
  WatchProvider() {
    getWatches('/api/v1/watch');
  }

  Future<void> getWatches(String endpoint, [int page = 1]) async {
  
    Uri uri = Uri.parse('$_urlBase$endpoint?page=$page');

    Response response = await get(uri);

    if (response.statusCode != 200) return;

    final Map<String, dynamic> decodedData = jsonDecode(response.body);

    decodedData.forEach((key, value) {
      Reloj relojTemp = Reloj.fromJson(value);

      relojTemp.id = key;

      watches.add(relojTemp);
    });

    notifyListeners();

  }
}