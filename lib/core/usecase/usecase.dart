import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failure.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}
