import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
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

  group('NumberTriviaRepositoryImpl', () {
    group('getConcreteNumberTrivia()', () {
      const int tNumber = 1;

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => true);
          // act
          repository.getConcreteNumberTrivia(tNumber);
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
      });

      group('device is offline', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => false);
        });
      });
    });
  });
}
