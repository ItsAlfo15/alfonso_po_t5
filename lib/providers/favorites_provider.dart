import 'dart:convert';

import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persiste los relojes favoritos en disco mediante shared_preferences.
/// Guarda el objeto completo (JSON) de cada reloj, para que los favoritos
/// estén disponibles aunque la API no responda.
class FavoritesProvider extends ChangeNotifier {
  static const _storageKey = 'favorites_watches';

  List<Reloj> _favorites = [];

  List<Reloj> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFromDisk();
  }

  // ── Comprobación ──────────────────────────────────────────────────────────

  bool isFavorite(String watchId) =>
      _favorites.any((r) => r.id == watchId);

  // ── Toggle ────────────────────────────────────────────────────────────────

  Future<void> toggleFavorite(Reloj reloj) async {
    if (isFavorite(reloj.id)) {
      _favorites.removeWhere((r) => r.id == reloj.id);
    } else {
      _favorites.add(reloj);
    }
    notifyListeners();
    await _saveToDisk();
  }

  // ── Persistencia ──────────────────────────────────────────────────────────

  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;

      final List<dynamic> decoded = jsonDecode(raw);
      _favorites = decoded.map((e) => Reloj.fromJson(e)).toList();
      notifyListeners();
    } catch (_) {
      _favorites = [];
    }
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_favorites.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (_) {
      // Error de escritura: no bloqueamos la UI
    }
  }

  /// Limpia todos los favoritos del disco y de memoria.
  Future<void> clearAll() async {
    _favorites = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
