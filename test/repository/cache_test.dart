import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/repository/cache.dart';
import 'package:template_flutter/resource/endpoint.dart';

import '../mock_classes.dart';

void main() {
  group('CacheService tests', () {
    test("hasLocalData true", () {
      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.getDynamic(any())).thenReturn("data");

      final cacheService = CacheService("");
      expect(cacheService.hasLocalData(), true);
    });

    test("isValid _expiresFieldName null", () {
      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.get(any())).thenReturn(null);

      final cacheService = CacheService("");
      expect(cacheService.isValid(), false);
    });

    test("isValid false", () {
      DateTime future = DateTime.now().add(const Duration(days: -1));
      String url = "testUrl";
      EndpointList api = EndpointList.values.first;
      String expiresFieldName = "CachedData_${url}_DateTime";

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.get(expiresFieldName))
          .thenReturn(future.toString());
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);

      final cacheService = CacheService(url);
      expect(cacheService.isValid(), false);
    });

    test("isValid true", () {
      DateTime future = DateTime.now().add(const Duration(days: 1));
      String url = "testUrl";
      EndpointList api = EndpointList.values.first;
      String expiresFieldName = "CachedData_${url}_DateTime";

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.get(expiresFieldName))
          .thenReturn(future.toString());
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);

      final cacheService = CacheService(url);
      expect(cacheService.isValid(), true);
    });

    test("isResponseExpiredOffline true", () {
      String url = "testUrl";
      EndpointList api = EndpointList.values.first;

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.get(any())).thenReturn("anyUrl");
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);

      final cacheService = CacheService(url);
      expect(cacheService.shouldResponseExpiredOffline(), true);
    });

    test("fetch true", () {
      String url = "testUrl";
      EndpointList api = EndpointList.values.first;
      String fieldName = "CachedData_$url";

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.getDynamic(fieldName)).thenReturn([1, 2, 3]);
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);

      final cacheService = CacheService(url);
      expect(cacheService.fetch(), isNotNull);
    });

    test("store false", () async {
      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;

      final cacheService = CacheService("");
      expect(cacheService.store(Response.bytes([], 500)), false);
    });

    test("store false because data no changes", () async {
      String url = "testUrl";
      EndpointList api =
          EndpointList.values.where((element) => element.checkChanges).first;
      String fieldName = "CachedData_$url";
      String expiresFieldName = "CachedData_${url}_DateTime";
      List<int> listData = [1, 2, 3];

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      for (var item in EndpointList.values) {
        when(() => globalConfigMock.get(item.name.name)).thenReturn("anyUrl");
      }
      when(() => globalConfigMock.getDynamic(fieldName)).thenReturn(listData);
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);
      when(() => globalConfigMock.get(api.expiration.name)).thenReturn("1");
      when(() => globalConfigMock.set(expiresFieldName, any()))
          .thenReturn(true);
      when(() => globalConfigMock.set(fieldName, any())).thenReturn(true);

      final cacheService = CacheService(url);
      expect(cacheService.store(Response.bytes(listData, 200)), false);
    });

    test("store true", () async {
      String url = "testUrl";
      EndpointList api = EndpointList.values.first;
      String fieldName = "CachedData_$url";
      String expiresFieldName = "CachedData_${url}_DateTime";
      List<int> listDataOld = [1, 2, 3];
      List<int> listDataNew = [3, 2, 1];

      final globalConfigMock = MockGlobalConfig();
      GlobalConfig.instance = globalConfigMock;
      when(() => globalConfigMock.getDynamic(fieldName))
          .thenReturn(listDataOld);
      when(() => globalConfigMock.get(api.name.name)).thenReturn(url);
      when(() => globalConfigMock.get(api.expiration.name)).thenReturn("1");
      when(() => globalConfigMock.set(expiresFieldName, any()))
          .thenReturn(true);
      when(() => globalConfigMock.set(fieldName, any())).thenReturn(true);

      final cacheService = CacheService(url);
      expect(cacheService.store(Response.bytes(listDataNew, 200)), true);
    });
  });
}
