import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
