// lib/services/storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

class StorageService {
  static const String _key = 'bmi_records';

  Future<List<BmiRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    final records = jsonList
        .map((e) => BmiRecord.fromJson(e as Map<String, dynamic>))
        .toList();

    // Sort descending by date
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  Future<void> saveRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await loadRecords();
    records.add(record);
    final jsonStr = json.encode(records.map((r) => r.toJson()).toList());
    await prefs.setString(_key, jsonStr);
  }

  Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await loadRecords();
    records.removeWhere((r) => r.id == id);
    final jsonStr = json.encode(records.map((r) => r.toJson()).toList());
    await prefs.setString(_key, jsonStr);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
