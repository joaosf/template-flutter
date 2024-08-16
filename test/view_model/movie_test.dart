import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_flutter/resource/application_exception.dart';
import 'package:template_flutter/resource/global_exception_message.dart';
import 'package:template_flutter/view_model/movie.dart';

import '../mock_classes.dart';

class MockCallbackFunction extends Mock {
  call();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockRepository = MockMovieRepository();
  final viewModel = MovieViewModel(repository: mockRepository);

  group('MovieViewModel flow', () {
    test("MovieViewModel Successful tests", () async {
      when(mockRepository.getAll)
          .thenAnswer((_) => Future.value([mockMovieModel]));

      viewModel.load();

      viewModel.addListener(() {
        expect(viewModel.getAll().length, 1);
        expect(
            viewModel.getByTitle(mockMovieModel.title), isNot(throwsException));
      });
    });

    test("MovieViewModel genericInternalError test", () async {
      String exceptionMessage = GlobalException.genericInternalError.message;
      when(mockRepository.getAll).thenAnswer(
          (_) => Future.error(ApplicationException(exceptionMessage)));

      viewModel.load();

      viewModel.addListener(() {
        expect(viewModel.exception.toString(), exceptionMessage);
      });
    });
  });
}
