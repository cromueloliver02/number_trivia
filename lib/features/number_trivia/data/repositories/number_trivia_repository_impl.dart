import 'package:fpdart/fpdart.dart';
import 'package:number_trivia/core/error/exceptions.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    try {
      final bool isConnected = await networkInfo.isConnected;

      if (isConnected) {
        final NumberTriviaModel remoteNumberTriviaModel =
            await remoteDataSource.getConcreteNumberTrivia(number);

        await localDataSource.cacheNumberTrivia(remoteNumberTriviaModel);

        return Right(remoteNumberTriviaModel.toEntity());
      } else {
        final NumberTriviaModel localNumberTriviaModel =
            await localDataSource.getLastNumberTrivia();

        return Right(localNumberTriviaModel.toEntity());
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    try {
      final bool isConnected = await networkInfo.isConnected;

      if (isConnected) {
        final NumberTriviaModel remoteNumberTriviaModel =
            await remoteDataSource.getRandomNumberTrivia();

        await localDataSource.cacheNumberTrivia(remoteNumberTriviaModel);

        return Right(remoteNumberTriviaModel.toEntity());
      } else {
        final NumberTriviaModel localNumberTriviaModel =
            await localDataSource.getLastNumberTrivia();

        return Right(localNumberTriviaModel.toEntity());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
