import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/repository/http_request.dart';
import 'package:template_flutter/repository/movie.dart';

import '../mock_classes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockHttpRequests = MockHttpRequests();
  GlobalConfig.instance = MockGlobalConfigEmpty();

  group('MovieRepository flow', () {
    test("MovieRepository Successful tests", () async {
      // Arrange
      final mockHttpResponse = http.Response(jsonEncode(mockMovieJson), 200);

      when(() => mockHttpRequests.get(any()))
          .thenAnswer((_) => Future.value(mockHttpResponse));

      HttpRequests.instance = mockHttpRequests;

      // Act
      final list = await MovieRepository().getAll();

      // Assert
      expect(list.length, mockMovieJson.length);
    });
  });
}
