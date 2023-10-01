import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'number': number});

    return result;
  }

  factory NumberTriviaModel.fromJson(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] ?? '',
      number: map['number']?.toInt() ?? 0,
    );
  }
}
