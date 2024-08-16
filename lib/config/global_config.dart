import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GlobalConfig extends GlobalConfigSharedPreferences {
  static GlobalConfig? _instance;

  GlobalConfig._();

  static GlobalConfig get instance => _instance ??= GlobalConfig._();

  @visibleForTesting
  static set instance(GlobalConfig instance) => _instance = instance;
}

class GlobalConfigSharedPreferences {
  final GetStorage _storage = GetStorage();
  Timer? _timer;

  _save() => _timer ??= Timer(const Duration(seconds: 5), timerRun);

  @visibleForTesting
  timerRun() async {
    await _storage.save();
    _timer?.cancel();
    _timer = null;
  }

  set(String key, String value) {
    _storage.writeInMemory(key, value);
    _save();
  }

  setList(String key, List<String> value) {
    _storage.writeInMemory(key, value);
    _save();
  }

  setDynamic(String key, dynamic value) {
    _storage.writeInMemory(key, value);
    _save();
  }

  remove(String key) {
    return _storage.remove(key);
  }

  String? get(String key) {
    return _storage.read(key);
  }

  List<dynamic>? getList(String key) {
    return _storage.read(key);
  }

  dynamic getDynamic(String key) {
    return _storage.read(key);
  }

  Iterable keys() {
    return _storage.getKeys();
  }
}
