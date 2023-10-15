import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const int tNumber = 1;
  const NumberTrivia tNumberTrivia =
      NumberTrivia(text: 'test trivia', number: tNumber);
  const Failure tFailure = Failure();

  test(
    'should get concrete [NumberTrivia] for the number from the repository when success',
    () async {
      // arrange
      when(
        () => mockNumberTriviaRepository.getConcreteNumberTrivia(any<int>()),
      ).thenAnswer((invocation) async => const Right(tNumberTrivia));
      // act
      final result =
          await usecase(const GetConcreteNumberTriviaParams(number: tNumber));
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

  test(
    'should return [Failure] for the number from the repository when failed',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any<int>()))
          .thenAnswer((invocation) async => const Left(tFailure));
      // act
      final result =
          await usecase(const GetConcreteNumberTriviaParams(number: tNumber));
      // assert
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      expect(result, const Left(tFailure));
    },
  );
}
