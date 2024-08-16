import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/models/application_exception.dart';
import 'package:template_flutter/repository/http_request.dart';
import 'package:template_flutter/resource/endpoint.dart';
import 'package:template_flutter/resource/global_exception_message.dart';

import '../mock_classes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HttpRequests flow', () {
    MockCacheService getCacheServiceMock(bool withData,
        {dynamic data,
        bool? store,
        bool? isValid,
        bool? shouldResponseExpiredOffline}) {
      final cacheServiceMock = MockCacheService();

      when(cacheServiceMock.hasLocalData).thenReturn(withData);
      when(cacheServiceMock.isValid).thenReturn(isValid ?? withData);
      when(cacheServiceMock.shouldResponseExpiredOffline)
          .thenReturn(shouldResponseExpiredOffline ?? withData);
      when(() => cacheServiceMock.store(any()))
          .thenAnswer((_) => store ?? withData);
      when(cacheServiceMock.fetch).thenReturn(data);

      return cacheServiceMock;
    }

    setGlobalConfigMock() {
      final globalConfigMock = MockGlobalConfig();

      for (var endpoint in EndpointList.values) {
        when(() => globalConfigMock.get(endpoint.name.name)).thenReturn('');
        when(() => globalConfigMock.get(endpoint.expiration.name))
            .thenReturn('10000');
      }

      GlobalConfig.instance = globalConfigMock;
    }

    setUpAll(() {
      registerFallbackValue(MockResponse());
      setGlobalConfigMock();
    });

    test("Fail with no connection", () async {
      final cacheServiceMock = getCacheServiceMock(false);

      var httpRequests = HttpRequests(isConnected: false);

      var response = await httpRequests.get(urlAuthorizedMock,
          cacheService: cacheServiceMock);
      expect(response.statusCode, 503);
    });

    test("Successful get tests", () async {
      final cacheServiceMock = getCacheServiceMock(false);

      var httpRequests = HttpRequests(isConnected: true);

      var response = await httpRequests.get(urlAuthorizedMock,
          cacheService: cacheServiceMock);
      expect(response.statusCode, 200);
    });

    test("Successful post tests", () async {
      final cacheServiceMock = getCacheServiceMock(false);

      var httpRequests = HttpRequests(isConnected: true);

      var response = httpRequests.post(urlAuthorizedMock, "body",
          cacheService: cacheServiceMock);
      expect(() => response, throwsException);
    });

    test("Successful tests with cacheData", () async {
      final mockResponse = Response("mock", 200);
      final cacheServiceMock = getCacheServiceMock(true, data: mockResponse);

      var httpRequests = HttpRequests(isConnected: true);

      var response = await httpRequests.get(urlAuthorizedMock,
          cacheService: cacheServiceMock);

      expect(response.statusCode, mockResponse.statusCode);
    });

    test("Successful tests with cacheData, invalid and no connection",
        () async {
      final mockResponse = Response("mock", 200);
      final cacheServiceMock = getCacheServiceMock(true,
          data: mockResponse,
          isValid: false,
          shouldResponseExpiredOffline: true);

      var httpRequests = HttpRequests(isConnected: false);

      var response = await httpRequests.get(urlAuthorizedMock,
          cacheService: cacheServiceMock);

      expect(response.statusCode, mockResponse.statusCode);
    });
  });

  group('ResponseError tests', () {
    test('Response 204 tests', () {
      try {
        ResponseError.process(204);
      } catch (exception) {
        expect(exception, isA<ApplicationException>());

        expect((exception as ApplicationException).message,
            GlobalException.genericNoContent.message);
      }
    });
    test('Response 401 tests', () {
      try {
        ResponseError.process(401);
      } catch (exception) {
        expect(exception, isA<ApplicationException>());

        expect((exception as ApplicationException).message,
            GlobalException.genericUnauthorized.message);
      }
    });
    test('Response 500 tests', () {
      try {
        ResponseError.process(500);
      } catch (exception) {
        expect(exception, isA<ApplicationException>());

        expect((exception as ApplicationException).message,
            GlobalException.genericInternalError.message);
      }
    });
    test('Response 503 tests', () {
      try {
        ResponseError.process(503);
      } catch (exception) {
        expect(exception, isA<ApplicationException>());

        expect((exception as ApplicationException).message,
            GlobalException.genericUnavailableService.message);
      }
    });

    test('Response 400 tests', () {
      try {
        ResponseError.process(400);
      } catch (exception) {
        expect(exception, isA<ApplicationException>());

        expect((exception as ApplicationException).message,
            GlobalException.genericUnavailableService.message);
      }
    });
  });
}
