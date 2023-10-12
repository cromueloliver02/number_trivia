import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/constants/constants.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSource numberTriviaLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final String tNumberTriviaJson = fixture('trivia_cache.json');
  final NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel.fromJson(jsonDecode(tNumberTriviaJson));

  group('getLastNumberTrivia()', () {
    test(
      'should return [NumberTriviaModel] from the SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any<String>()))
            .thenReturn(tNumberTriviaJson);
        // act
        final result = await numberTriviaLocalDataSource.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferences.getString(cacheNumberTriviaKey));
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw [CacheException] when there is no cached data',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any<String>()))
            .thenReturn(null);
        // act
        final result = numberTriviaLocalDataSource.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferences.getString(cacheNumberTriviaKey));
        expect(result, throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });
}
