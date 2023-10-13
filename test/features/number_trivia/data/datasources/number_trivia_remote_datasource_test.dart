import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';

import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSource = NumberTriviaRemoteDataSourceImpl(
      httpClient: mockHttpClient,
    );
  });

  group('getConcreteNumberTrivia()', () {
    const int tNumber = 1;
    final String tNumberTriviaJson = fixture('trivia.json');
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(tNumberTriviaJson));

    test(
      '''
        should perform a GET request on a URL with number being the endpoint and
        with application/json header
      ''',
      () async {
        // arrange
        when(() => mockHttpClient.get(
                  Uri.parse('http://numbersapi.com/$tNumber'),
                  headers: {'Content-Type': 'application/json'},
                ))
            .thenAnswer(
                (invocation) async => http.Response(tNumberTriviaJson, 200));
        // act
        await numberTriviaRemoteDataSource.getConcreteNumberTrivia(1);
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test(
      'should return [NumberTriviaModel] when the response status code is 200 (success)',
      () async {
        // arrange
        when(() => mockHttpClient.get(
                  Uri.parse('http://numbersapi.com/$tNumber'),
                  headers: {'Content-Type': 'application/json'},
                ))
            .thenAnswer(
                (invocation) async => http.Response(tNumberTriviaJson, 200));
        // act
        final result =
            await numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ));
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a [ServerException] when the response status code is NOT 200 (failure)',
      () async {
        // arrange
        when(() => mockHttpClient.get(
                  Uri.parse('http://numbersapi.com/$tNumber'),
                  headers: {'Content-Type': 'application/json'},
                ))
            .thenAnswer((invocation) async =>
                http.Response('Something went wrong', 500));
        // act
        final result =
            numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ));
        expect(result, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
