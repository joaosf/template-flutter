import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/models/movie.dart';
import 'package:template_flutter/repository/cache.dart';
import 'package:template_flutter/repository/http_request.dart';
import 'package:template_flutter/repository/movie.dart';

String urlUnauthorizedMock = "https://mock.httpstatus.io/401";
String urlAuthorizedMock = "https://mock.httpstatus.io/200";

class MockGlobalConfig extends Mock implements GlobalConfig {}

class MockGlobalConfigEmpty extends Mock implements GlobalConfig {
  @override
  String get(String key) {
    return "";
  }

  @override
  List<String> getList(String key) {
    return [];
  }
}

class MockCacheService extends Mock implements CacheService {}

class MockResponse extends Mock implements Response {}

class MockHttpRequests extends Mock implements HttpRequests {}

class MockMovieRepository extends Mock implements MovieRepository {}

final mockMovieJson = [
  {
    "id": 1,
    "title": "The Shawshank Redemption",
    "year": 1994,
    "genre": ["Drama"],
    "rating": 9.3,
    "director": "Frank Darabont",
    "actors": ["Tim Robbins", "Morgan Freeman"],
    "plot":
        "Two imprisoned men bond over several years, finding solace and eventual redemption through acts of common decency.",
    "poster": "https://fakeimg.pl/220x310/ff0000",
    "trailer": "https://example.com/shawshank_redemption_trailer.mp4",
    "runtime": 142,
    "awards": "Nominated for 7 Oscars",
    "country": "USA",
    "language": "English",
    "boxOffice": "\$28.3 million",
    "production": "Columbia Pictures",
    "website": "http://www.warnerbros.com/movies/shawshank-redemption"
  }
];

final mockMovieModel = MovieModel(
  title: "The Shawshank Redemption",
  director: "Frank Darabont",
);
