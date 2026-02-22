import 'dart:convert';

import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WatchProvider extends ChangeNotifier {
  final String _urlBase = 'https://backend-relojes-mejorado.onrender.com/api/v1';

  List<Reloj> watches = [];

  WatchProvider() {
    getWatches(endpoint: '/watch', limit: 30);
  }

  Future<void> getWatches({
    String endpoint = '/watch',
    int page = 1,
    int limit = 5,
  }) async {
    if (watches.isNotEmpty) return;

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

  List<Reloj> relojesPorMarca(String marca) {
    return watches
        .where((r) => r.marca.toLowerCase() == marca.toLowerCase())
        .toList();
  }
}
