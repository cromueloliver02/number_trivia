part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

final class NumberTriviaInitial extends NumberTriviaState {}

final class NumberTriviaInProgress extends NumberTriviaState {}

final class NumberTriviaSuccess extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaSuccess({
    required this.trivia,
  });

  @override
  List<Object> get props => [trivia];
}

final class NumberTriviaFailure extends NumberTriviaState {
  final Failure failure;

  const NumberTriviaFailure({
    required this.failure,
  });

  @override
  List<Object> get props => [failure];
}
