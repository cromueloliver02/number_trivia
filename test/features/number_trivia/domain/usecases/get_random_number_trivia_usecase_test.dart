import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTrivia sut;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    sut = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const NumberTrivia tNumberTrivia =
      NumberTrivia(text: 'test trivia', number: 1);
  const Failure tFailure = Failure();

  test(
    'should get random [NumberTrivia] from the repository when success',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((invocation) async => const Right(tNumberTrivia));
      // act
      final result = await sut(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

  test(
    'should return [Failure] from the repository when failed',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((invocation) async => const Left(tFailure));
      // act
      final result = await sut(NoParams());
      // assert
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      expect(result, const Left(tFailure));
    },
  );
}
