import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/resource/endpoint.dart';
import 'package:template_flutter/resource/global_envs.dart';

class CacheService {
  final String _url;
  GlobalConfig globalConfig = GlobalConfig.instance;
  static const String _prefix = "CachedData_";
  static const String _expiresIn = "_DateTime";

  CacheService(this._url);

  String _expiresFieldName() => "$_prefix$_url$_expiresIn";

  String _fieldName() => "$_prefix$_url";

  bool hasLocalData() {
    return globalConfig.getDynamic(_fieldName()) != null;
  }

  bool isValid() {
    String? expiresIn = globalConfig.get(_expiresFieldName());
    if (expiresIn == null) {
      return false;
    }

    for (var endpoint in EndpointList.values) {
      String endpointValue = endpoint.name.value;
      if (_url.contains(endpointValue)) {
        return DateTime.now().isBefore(DateTime.parse(expiresIn));
      }
    }
    return false;
  }

  bool shouldResponseExpiredOffline() {
    for (var endpoint in EndpointList.values) {
      String endpointValue = endpoint.name.value;
      if (_url.contains(endpointValue)) {
        return endpoint.responseExpiredOffline;
      }
    }
    return false;
  }

  fetch() {
    for (var endpoint in EndpointList.values) {
      String endpointValue = endpoint.name.value;
      if (_url.contains(endpointValue)) {
        List? previousData = globalConfig.getDynamic(_fieldName()) as List?;

        return http.Response.bytes(previousData!.cast(), 200);
      }
    }
    return;
  }

  bool store(http.Response data) {
    if (data.statusCode != 200) {
      return false;
    }

    for (var endpoint in EndpointList.values) {
      String endpointValue = endpoint.name.value;
      if (_url.contains(endpointValue)) {
        List? previousData = globalConfig.getDynamic(_fieldName()) as List?;
        Uint8List newData = data.bodyBytes;

        if (endpoint.checkChanges && previousData != null) {
          Uint8List previousDataUint8List =
              Uint8List.fromList(previousData.cast());

          if (newData.equals(previousDataUint8List)) {
            return false;
          }
        }

        int expiration = int.parse(endpoint.expiration.value);
        DateTime expiresAt = DateTime.now().add(Duration(minutes: expiration));

        globalConfig.set(_expiresFieldName(), expiresAt.toString());
        globalConfig.setDynamic(_fieldName(), newData);

        return true;
      }
    }
    return false;
  }

  static clearAll(GlobalConfig globalConfig) async {
    var keys = globalConfig.keys();
    var toDelete = [];

    for (var key in keys) {
      if (key.toString().startsWith(_prefix)) {
        toDelete.add(key);
      }
    }

    for (var key in toDelete) {
      await globalConfig.remove(key);
    }
  }
}
