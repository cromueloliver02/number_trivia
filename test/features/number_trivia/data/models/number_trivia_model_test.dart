import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('NumberTrivia model', () {
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: 'Test text', number: 1);

    test(
      'should be a subclass of NumberTrivia entity',
      () async {
        // assert
        expect(tNumberTriviaModel, isA<NumberTrivia>());
      },
    );

    group('fromJson()', () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    });

    group('toJson()', () {
      test(
        'should return a JSON map containing proper data',
        () async {
          // act
          final result = tNumberTriviaModel.toJson();
          // assert
          final Map<String, dynamic> expectedMap = {
            'text': 'Test text',
            'number': 1,
          };
          expect(result, expectedMap);
        },
      );
    });
  });
}
