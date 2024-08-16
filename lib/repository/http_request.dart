import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:template_flutter/repository/cache.dart';
import 'package:template_flutter/repository/utils.dart';
import 'package:template_flutter/resource/application_exception.dart';
import 'package:template_flutter/resource/global_exception_message.dart';

enum RequestType { get, post }

class HttpRequests {
  static HttpRequests? _instance;

  HttpRequests._();

  static HttpRequests get instance => _instance ??= HttpRequests._();

  @visibleForTesting
  static set instance(HttpRequests instance) => _instance = instance;

  bool? isConnected;

  HttpRequests({this.isConnected});

  Future<http.Response> get(String url, {CacheService? cacheService}) {
    return execute(url, cacheService: cacheService);
  }

  Future<http.Response> post(String url, String body,
      {CacheService? cacheService}) {
    return execute(url, requestType: RequestType.post, bodyData: body);
  }

  Future<http.Response> execute(String url,
      {CacheService? cacheService,
        String? bodyData,
        RequestType requestType = RequestType.get}) async {
    HttpOverrides.global = MyHttpOverrides();

    cacheService = cacheService ?? CacheService(url);
    isConnected = isConnected ?? await Utils.hasConnection();

    if (cacheService.hasLocalData()) {
      if (cacheService.isValid() ||
          (!isConnected! && cacheService.shouldResponseExpiredOffline())) {
        return cacheService.fetch();
      }
    }

    if (!isConnected!) {
      return http.Response('Service Unavailable', 503);
    }

    final request = (requestType == RequestType.get
        ? http.get(Uri.parse(url), headers: {
      'Accept': '*/*'
    })
        : http.post(Uri.parse(url),
        headers: {
          'Accept': '*/*',
          'Accept-Encoding': 'gzip',
          "Content-Type": "application/json"
        },
        body: bodyData))
        .timeout(const Duration(seconds: 60),
        onTimeout: () => http.Response('Request Timeout', 408));

    return Future.value(request).then((response) async {
      ResponseError.process(response.statusCode);

      cacheService!.store(response);
      return response;
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ResponseError {
  static process(int statusCode) {
    switch (statusCode) {
      case 200:
        return;
      case 204:
        throw ApplicationException(GlobalException.genericNoContent.message);
      case 401:
        throw ApplicationException(GlobalException.genericUnauthorized.message);
      case 500:
        throw ApplicationException(
            GlobalException.genericInternalError.message);
      case 503:
      default:
        throw ApplicationException(
            GlobalException.genericUnavailableService.message);
    }
  }
}
