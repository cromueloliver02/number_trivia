import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/constants/constants.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences _sharedPreferences;

  const NumberTriviaLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final String? numberTriviaJson =
        _sharedPreferences.getString(cacheNumberTriviaKey);

    if (numberTriviaJson == null) throw CacheException();

    final NumberTriviaModel numberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(numberTriviaJson));

    return numberTriviaModel;
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    throw UnimplementedError();
  }
}
