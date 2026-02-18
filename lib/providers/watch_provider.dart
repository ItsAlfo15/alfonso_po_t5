import 'dart:convert';

import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WatchProvider extends ChangeNotifier {
  final String _urlBase = 'https://alfonso-backend-relojes.onrender.com';

  List<Reloj> watches = [];

  WatchProvider() {
    getWatches(endpoint: '/api/v1/watch', limit: 24);
  }

  Future<void> getWatches({ String endpoint = '/api/v1/watch', int page = 1, int limit = 5 }) async {
  
    // Construyo y parseo la url
    Uri uri = Uri.parse('$_urlBase$endpoint?limit=$limit');

    // Guardo la respuesta de la peticion en una Response
    Response response = await get(uri);

    // Si la peticon es fallida retorno
    if (response.statusCode != 200) return;
    
    //print('DATA EXTRAIDA');

    // Convierto el String que me viene de la respuesta a un objeto con el que poder trabajar
    final WatchResponse watchResponse = watchResponseFromJson(response.body);

    //print('WATCH RESPONSE ${watchResponse.data}');

    // Guardo la data que es una lista de relojes en mi variable y envio una señal
    watches.addAll(watchResponse.data);
   
    //print('RELOJES: $watches');

    notifyListeners();

  }
}