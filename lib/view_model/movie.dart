import 'package:flutter/material.dart';
import 'package:template_flutter/models/movie.dart';
import 'package:template_flutter/repository/movie.dart';
import 'package:template_flutter/resource/application_exception.dart';

class MovieViewModel extends ChangeNotifier {
  final List<MovieModel> _items = List<MovieModel>.empty(growable: true);
  ApplicationException? _exception;

  bool isAuthorized = true;
  bool hasInternalError = false;

  MovieRepository? repository;

  MovieViewModel({this.repository});

  _setupRepository() => repository = repository ?? MovieRepository();

  load() {
    _setupRepository();
    repository!.getAll().then((value) {
      _items.clear();
      _items.addAll(value);
      notifyListeners();
    }).catchError((error) {
      print(error);
      _exception = error;
      notifyListeners();
    });
  }

  MovieModel? getByTitle(String title) =>
      _items.where((element) => element.title == title).first;

  List<MovieModel> getAll() => _items;

  ApplicationException? get exception => _exception;
}
