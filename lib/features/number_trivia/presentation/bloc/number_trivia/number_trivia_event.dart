part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

final class NumberTriviaConcreteLoaded extends NumberTriviaEvent {
  final String number;

  const NumberTriviaConcreteLoaded({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}

final class NumberTriviaRandomLoaded extends NumberTriviaEvent {}
