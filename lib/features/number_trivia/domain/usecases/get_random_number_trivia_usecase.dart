import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository _numberTriviaRepository;

  const GetRandomNumberTrivia(this._numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    return _numberTriviaRepository.getRandomNumberTrivia();
  }
}
