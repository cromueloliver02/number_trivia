import 'package:http/http.dart' as http;

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
    _httpClient.get(uri, headers: headers);

    return const NumberTriviaModel(text: 'trivia test', number: 1);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
