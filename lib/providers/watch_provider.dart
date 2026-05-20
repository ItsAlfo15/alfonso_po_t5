import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart';

class WatchProvider extends ChangeNotifier {
  final String _urlBase =
      'https://backend-relojes-mejorado.onrender.com/api/v1';

  List<Reloj> watches = [];
  bool isLoading = false;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // Relojes filtrados por busqueda
  List<Reloj> get filteredWatches {
    if (_searchQuery.isEmpty) return watches;
    final q = _searchQuery.toLowerCase();
    return watches.where((r) {
      return r.marca.toLowerCase().contains(q) ||
          r.modelo.toLowerCase().contains(q) ||
          r.referencia.toLowerCase().contains(q) ||
          r.descripcionResumida.toLowerCase().contains(q);
    }).toList();
  }

  WatchProvider() {
    getWatches();
  }

  Future<void> getWatches({String endpoint = '/watch', int limit = 30}) async {
    if (watches.isNotEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse('$_urlBase$endpoint?limit=$limit');
      final response = await get(uri);

      if (response.statusCode != 200) return;

      final watchResponse = watchResponseFromJson(response.body);
      watches.addAll(watchResponse.data);

      // ── Actualizar Home Screen Widget ──────────────────────────────────
      await _updateHomeWidget();
    } catch (_) {
      // Fallo silencioso; la UI mostrará lista vacía
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Relojes filtrados por marca (para BrandWatchesPage)
  List<Reloj> relojesPorMarca(String marca) {
    return watches
        .where((r) => r.marca.toLowerCase() == marca.toLowerCase())
        .toList();
  }

  // ── Home Screen Widget ─────────────────────────────────────────────────────
  Future<void> _updateHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<int>('total_watches', watches.length);
      await HomeWidget.saveWidgetData<String>(
        'featured_watch',
        watches.isNotEmpty
            ? '${watches.first.marca} ${watches.first.modelo}'
            : 'LuxWatch',
      );
      await HomeWidget.saveWidgetData<String>(
        'featured_price',
        watches.isNotEmpty ? '${watches.first.precio}€' : '',
      );
      await HomeWidget.updateWidget(
        name: 'LuxWatchWidgetProvider', // Android AppWidgetProvider class
        iOSName: 'LuxWatchWidget', // iOS Widget name
        qualifiedAndroidName:
            'com.example.alfonso_po_t5.LuxWatchWidgetProvider',
      );
    } catch (_) {
      // home_widget puede fallar en web/desktop — ignorar
    }
  }
}
