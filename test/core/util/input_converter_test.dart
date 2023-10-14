import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:number_trivia/core/error/failures.dart';

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
        const String str = '123';
        // act
        final result = inputConverter.stringToUnsignedInt(str);
        // assert
        expect(result, Right(int.parse(str)));
      },
    );

    test(
      'should return [FormatFailure] when the string is not an integer',
      () async {
        // arrange
        const String str = 'abc'; // 12.3 throws FormatException as well
        // act
        final result = inputConverter.stringToUnsignedInt(str);
        // assert
        expect(result, Left(FormatFailure()));
      },
    );

    test(
      'should return [FormatFailure] when the string is a negative integer',
      () async {
        // arrange
        const String str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInt(str);
        // assert
        expect(result, Left(FormatFailure()));
      },
    );
  });
}