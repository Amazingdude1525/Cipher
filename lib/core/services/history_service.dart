import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class HistoryService {
  static Box get _box => Hive.box(AppConstants.hiveHistoryBox);

  /// Save a scan result to local history.
  static void save({required String data, required String type}) {
    _box.add({
      'data': data,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get all history items, newest first.
  static List<Map<String, dynamic>> getAll() {
    final items = <Map<String, dynamic>>[];
    for (var i = _box.length - 1; i >= 0; i--) {
      final raw = _box.getAt(i);
      if (raw is Map) {
        items.add(Map<String, dynamic>.from(raw));
      }
    }
    return items;
  }

  /// Get count of stored items.
  static int get count => _box.length;

  /// Delete a single entry by its Hive index.
  static void deleteAt(int hiveIndex) {
    _box.deleteAt(hiveIndex);
  }

  /// Clear all history.
  static void clearAll() {
    _box.clear();
  }
}
