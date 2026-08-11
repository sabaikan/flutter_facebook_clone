import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  static const _storageKey = 'favorites';

  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) => _favorites.any((item) => item['id'] == id);

  Future<void> initStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      _favorites = decoded.cast<Map<String, dynamic>>();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> item) async {
    final exists = _favorites.any((f) => f['id'] == item['id']);
    if (exists) {
      _favorites.removeWhere((f) => f['id'] == item['id']);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_favorites));
  }
}
