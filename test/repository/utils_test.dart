import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_flutter/repository/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const testMockStorage = './test/fixtures/core';
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return testMockStorage;
    });
  });

  group('Utils static methods', () {
    test('bool isTesting', () {
      expect(Utils.isTesting, true);
    });

    test('generateRandomString', () {
      expect(Utils.generateRandomString(10).length, 10);
    });

    test('getPath', () async {
      expect(Utils.getPath(), isNotNull);
    });

    test('hasConnection', () async {
      expect(await Utils.hasConnection(), true);
    });
  });
}
