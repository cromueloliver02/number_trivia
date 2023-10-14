import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String number) {
    try {
      return Right(int.parse(number));
    } on FormatException {
      return Left(FormatFailure());
    }
  }
}
