import 'dart:convert';

import 'package:template_flutter/models/movie.dart';
import 'package:template_flutter/repository/contracts/movie.dart';
import 'package:template_flutter/repository/repository.dart';
import 'package:template_flutter/resource/global_envs.dart';

class MovieRepository extends BaseRepository {
  MovieModel fromJson(Map<String, dynamic> json) {
    MovieContract contract = MovieContract.fromJson(json);

    return MovieModel(
      title: contract.title,
      director: contract.director,
    );
  }

  Iterable<MovieModel> fromJsonList(List<dynamic> json) sync* {
    for (var item in json) {
      yield fromJson(item);
    }
  }

  Future<List<MovieModel>> getAll() async {
    String baseUrl = GlobalEnvs.apiBaseUrl.value;
    String endpoint = GlobalEnvs.endpointDemo.value;

    final response = await httpRequests.get('$baseUrl$endpoint');

    List json = jsonDecode(utf8.decode(response.bodyBytes));
    return fromJsonList(json).toList();
  }
}
