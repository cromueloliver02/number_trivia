import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    required this.text,
    required this.number,
  });

  @override
  String toString() => 'NumberTrivia(text: $text, number: $number)';

  @override
  List<Object> get props => <Object>[text, number];

  NumberTrivia copyWith({
    String? text,
    int? number,
  }) {
    return NumberTrivia(
      text: text ?? this.text,
      number: number ?? this.number,
    );
  }
}
