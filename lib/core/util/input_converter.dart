import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String string) {
    try {
      final int integer = int.parse(string);

      if (integer < 0) {
        throw const FormatException('Negative integer is invalid');
      }

      return Right(integer);
    } on FormatException catch (err) {
      return Left(FormatFailure(
        message: err.message,
        exception: err,
      ));
    }
  }
}
