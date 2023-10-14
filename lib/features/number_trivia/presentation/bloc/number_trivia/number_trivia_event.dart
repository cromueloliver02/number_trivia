part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

final class ConcreteNumberTriviaLoaded extends NumberTriviaEvent {
  final int number;

  const ConcreteNumberTriviaLoaded({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}

final class RandomNumberTriviaLoaded extends NumberTriviaEvent {}
