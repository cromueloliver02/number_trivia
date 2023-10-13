import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';

import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client _httpClient;

  NumberTriviaRemoteDataSourceImpl({
    required http.Client httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final Uri uri = Uri.parse('http://numbersapi.com/$number');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final http.Response response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode != HttpStatus.ok) throw ServerException();

    final NumberTriviaModel numberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(response.body));

    return numberTriviaModel;
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final http.Response response = await _httpClient.get(
      Uri.parse('http://numbersapi.com/random'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != HttpStatus.ok) throw ServerException();

    final NumberTriviaModel numberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(response.body));

    return numberTriviaModel;
  }
}
