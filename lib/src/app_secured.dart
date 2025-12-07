import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecured {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> saveString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> readString(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  static Future<bool?> readBool(String key) async {
    String? value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  static Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  static Future<void> saveStringList(String key, List<String> list) async {
    String encodedList = jsonEncode(list);
    await _secureStorage.write(key: key, value: encodedList);
  }

  static Future<List<String>?> readStringList(String key) async {
    String? encodedList = await _secureStorage.read(key: key);
    if (encodedList == null) return null;

    try {
      List<dynamic> decoded = jsonDecode(encodedList);
      return decoded.cast<String>();
    } catch (_) {
      return null;
    }
  }

  static Future<void> addToStringList(String key, String value) async {
    List<String>? currentList = await readStringList(key);

    currentList = currentList ?? [];
    if (!currentList.contains(value)) {
      currentList.add(value);
    }

    await saveStringList(key, currentList);
  }

  static Future<bool> ifListContains(String key, String value) async {
    List<String>? currentList = await readStringList(key);
    if (currentList == null) return false;
    return currentList.contains(value);
  }
}
