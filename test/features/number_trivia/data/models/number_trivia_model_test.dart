import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

void main() {
  group('NumberTrivia model', () {
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: 'test', number: 1);

    test(
      'should be a subclass of NumberTrivia entity',
      () async {
        // assert
        expect(tNumberTriviaModel, isA<NumberTrivia>());
      },
    );
  });
}
