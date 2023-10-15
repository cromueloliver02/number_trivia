import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  final InputConverter _inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia getConcreteNumberTrivia,
    required GetRandomNumberTrivia getRandomNumberTrivia,
    required InputConverter inputConverter,
  })  : _getConcreteNumberTrivia = getConcreteNumberTrivia,
        _getRandomNumberTrivia = getRandomNumberTrivia,
        _inputConverter = inputConverter,
        super(NumberTriviaInitial()) {
    on<NumberTriviaConcreteLoaded>(_onNumberTriviaConcreteLoaded);
    on<NumberTriviaRandomLoaded>(_onNumberTriviaRandomLoaded);
  }

  Future<void> _onNumberTriviaConcreteLoaded(
    NumberTriviaConcreteLoaded event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaInProgress());

    final Either<Failure, int> eitherNumber =
        _inputConverter.stringToUnsignedInt(event.number);

    await eitherNumber.fold(
      (Failure failure) async => emit(NumberTriviaFailure(failure: failure)),
      (int number) async {
        final Either<Failure, NumberTrivia> eitherTrivia =
            await _getConcreteNumberTrivia(
          GetConcreteNumberTriviaParams(number: number),
        );

        eitherTrivia.fold(
          (Failure failure) => emit(NumberTriviaFailure(failure: failure)),
          (NumberTrivia trivia) => emit(NumberTriviaSuccess(trivia: trivia)),
        );
      },
    );
  }

  Future<void> _onNumberTriviaRandomLoaded(
    NumberTriviaRandomLoaded event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaInProgress());

    final Either<Failure, NumberTrivia> either =
        await _getRandomNumberTrivia(NoParams());

    either.fold(
      (Failure failure) => emit(NumberTriviaFailure(failure: failure)),
      (NumberTrivia trivia) => emit(NumberTriviaSuccess(trivia: trivia)),
    );
  }
}
