import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/search_history_item.dart';

class SearchHistoryData {
  static const _key = 'search_history';

  Future<List<SearchHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => SearchHistoryItem.fromJson(json.decode(e))).toList();
  }

  Future<void> addHistory(SearchHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.removeWhere((element) => element.word == item.word);
    history.insert(0, item);
    final data = history.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
