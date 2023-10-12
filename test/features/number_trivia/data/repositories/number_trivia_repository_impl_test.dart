import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepository repository;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const int tNumber = 1;
  const NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  final NumberTrivia tNumberTrivia = tNumberTriviaModel.toEntity();

  group('NumberTriviaRepositoryImpl', () {
    group('getConcreteNumberTrivia()', () {
      const int tNumber = 1;

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => true);
          // START - error fix
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
              .thenAnswer((invocation) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((invocation) => Future.value());
          // END - error fix
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(() => mockNetworkInfo.isConnected);
          verifyNoMoreInteractions(mockNetworkInfo);
        },
      );

      group(
        'device is online',
        () {
          setUp(() {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((invocation) async => true);
          });

          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(() =>
                      mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                  .thenAnswer((invocation) async => tNumberTriviaModel);
              // START - error fix
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((invocation) => Future.value());
              // END - error fix
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, Right(tNumberTrivia));
            },
          );

          test(
            'should cache data locally when the call to remote data source is successful',
            () async {
              // arrange
              // START - error fix
              when(() =>
                      mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                  .thenAnswer((invocation) async => tNumberTriviaModel);
              // END - error fix
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((invocation) => Future.value());
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verify(() =>
                  mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );

          test(
            'should return [ServerFailure] when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(() =>
                      mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                  .thenThrow(ServerException());
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((invocation) => Future.value());
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, Left(ServerFailure()));
            },
          );
        },
      );

      group('device is offline', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => false);
        });

        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()))
                .thenAnswer((invocation) async => tNumberTriviaModel);
            when(() =>
                    mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((invocation) => Future.value());
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            verifyZeroInteractions(mockRemoteDataSource);
            expect(result, Right(tNumberTrivia));
          },
        );

        test(
          'should return [CacheFailure] when there is no cached data present',
          () async {
            // arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            verifyZeroInteractions(mockRemoteDataSource);
            expect(result, Left(CacheFailure()));
          },
        );
      });
    });

    group('getRandomNumberTrivia()', () {
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => true);
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(() => mockNetworkInfo.isConnected);
          verifyNoMoreInteractions(mockNetworkInfo);
        },
      );

      group('device is online', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => true);
        });

        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            // act
            final result = await repository.getRandomNumberTrivia();
            // assert
            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, Right(tNumberTrivia));
          },
        );
      });
    });
  });
}
