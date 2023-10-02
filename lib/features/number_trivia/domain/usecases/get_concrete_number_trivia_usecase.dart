import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia
    implements UseCase<NumberTrivia, GetConcreteNumberTriviaParams> {
  final NumberTriviaRepository _numberTriviaRepository;

  const GetConcreteNumberTrivia(this._numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
    GetConcreteNumberTriviaParams params,
  ) {
    return _numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class GetConcreteNumberTriviaParams extends Equatable {
  final int number;

  const GetConcreteNumberTriviaParams({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}
