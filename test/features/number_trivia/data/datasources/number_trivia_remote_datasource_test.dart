import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

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
  });
}
