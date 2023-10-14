import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'NumberTriviaState should be initial state',
    () async {
      // act
      final result = bloc.state;
      // assert
      expect(result, NumberTriviaInitial());
    },
  );

  group(
    'NumberTriviaConcreteLoaded()',
    () {
      const String tNumberString = '123';
      final int tNumberParsed = int.parse(tNumberString);
      final NumberTrivia tNumberTrivia =
          NumberTrivia(text: 'test trivia', number: tNumberParsed);
      const Failure tFailure = Failure();

      void stubStringToUnsignedIntSuccess() {
        when(() => mockInputConverter.stringToUnsignedInt(any<String>()))
            .thenReturn(Right(tNumberParsed));
      }

      void stubStringToUnsignedIntFailure() {
        when(() => mockInputConverter.stringToUnsignedInt(any<String>()))
            .thenReturn(Left(FormatFailure()));
      }

      void stubGetConcreteNumberTriviaSuccess() {
        when(() => mockGetConcreteNumberTrivia(
                GetConcreteNumberTriviaParams(number: tNumberParsed)))
            .thenAnswer((invocation) async => Right(tNumberTrivia));
      }

      void stubGetConcreteNumberTriviaFailure() {
        when(() => mockGetConcreteNumberTrivia(
                GetConcreteNumberTriviaParams(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Left(Failure()));
      }

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          stubStringToUnsignedIntSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          bloc.add(const NumberTriviaConcreteLoaded(number: tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInt(any<String>()));
          // assert
          verify(() => mockInputConverter.stringToUnsignedInt(tNumberString));
        },
      );

      test(
        'should emit [NumberTriviaFailure] when the input is invalid',
        () async {
          // arrange
          stubStringToUnsignedIntFailure();
          stubGetConcreteNumberTriviaSuccess();
          // act
          bloc.add(const NumberTriviaConcreteLoaded(number: tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInt(any<String>()));
          final result = bloc.state;
          // assert
          expect(result, isA<NumberTriviaFailure>());
        },
      );

      test(
        'should get the data from the concrete use case',
        () async {
          // arrange
          stubStringToUnsignedIntSuccess();
          stubGetConcreteNumberTriviaSuccess();
          // act
          bloc.add(const NumberTriviaConcreteLoaded(number: tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInt(any<String>()));
          // assert
          verify(() => mockGetConcreteNumberTrivia(
              GetConcreteNumberTriviaParams(number: tNumberParsed)));
        },
      );

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''
      emits [NumberTriviaInProgress, NumberTriviaSuccess] when
      NumberTriviaConcreteLoaded is added and data is gotten successfully
      ''',
        build: () {
          stubStringToUnsignedIntSuccess();
          stubGetConcreteNumberTriviaSuccess();
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const NumberTriviaConcreteLoaded(number: tNumberString)),
        expect: () => <NumberTriviaState>[
          NumberTriviaInProgress(),
          NumberTriviaSuccess(trivia: tNumberTrivia),
        ],
      );

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''
      emits [NumberTriviaInProgress, NumberTriviaFailure] when
      NumberTriviaConcreteLoaded is added and getting data fails
      ''',
        build: () {
          stubStringToUnsignedIntSuccess();
          stubGetConcreteNumberTriviaFailure();
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const NumberTriviaConcreteLoaded(number: tNumberString)),
        expect: () => <NumberTriviaState>[
          NumberTriviaInProgress(),
          const NumberTriviaFailure(failure: tFailure),
        ],
      );
    },
  );

  group(
    'NumberTriviaRandomLoaded()',
    () {
      const NumberTrivia tNumberTrivia =
          NumberTrivia(text: 'test trivia', number: 1);
      const Failure tFailure = Failure();

      void stubGetRandomNumberTriviaSuccess() {
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));
      }

      void stubGetRandomNumberTriviaFailure() {
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((invocation) async => const Left(tFailure));
      }

      test(
        'should get the data from the random use case',
        () async {
          // arrange
          stubGetRandomNumberTriviaSuccess();
          // act
          bloc.add(NumberTriviaRandomLoaded());
          await untilCalled(() => mockGetRandomNumberTrivia(NoParams()));
          // assert
          verify(() => mockGetRandomNumberTrivia(NoParams()));
        },
      );

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''
        emits [NumberTriviaInProgress, NumberTriviaSuccess] when
        NumberTriviaRandomLoaded is added and data is gotten successfully
        ''',
        build: () {
          stubGetRandomNumberTriviaSuccess();
          return bloc;
        },
        act: (bloc) => bloc.add(NumberTriviaRandomLoaded()),
        expect: () => <NumberTriviaState>[
          NumberTriviaInProgress(),
          const NumberTriviaSuccess(trivia: tNumberTrivia),
        ],
      );

      blocTest<NumberTriviaBloc, NumberTriviaState>(
        '''
        emits [NumberTriviaInProgress, NumberTriviaFailure] when
        NumberTriviaRandomLoaded is added and getting data fails
        ''',
        build: () {
          stubGetRandomNumberTriviaFailure();
          return bloc;
        },
        act: (bloc) => bloc.add(NumberTriviaRandomLoaded()),
        expect: () => <NumberTriviaState>[
          NumberTriviaInProgress(),
          const NumberTriviaFailure(failure: tFailure),
        ],
      );
    },
  );
}
