import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String number) {
    return Right(int.parse(number));
  }
}
