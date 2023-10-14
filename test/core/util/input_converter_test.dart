import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt()', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        const String tNumberString = '123';
        // act
        final result = inputConverter.stringToUnsignedInt(tNumberString);
        // assert
        expect(result, Right(int.parse(tNumberString)));
      },
    );
  });
}
