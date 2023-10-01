import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  factory NumberTriviaModel.fromJson(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] ?? '',
      number: map['number']?.toInt() ?? 0,
    );
  }
}
