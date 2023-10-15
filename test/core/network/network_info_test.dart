import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late InternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl sut;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    sut = NetworkInfoImpl(
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final Future<bool> tHasConnectionFuture = Future.value(true);
        when(() => mockInternetConnectionChecker.hasConnection)
            .thenAnswer((invocation) => tHasConnectionFuture);
        // act
        final result = sut.isConnected;
        // assert
        verify(() => mockInternetConnectionChecker.hasConnection);
        // test if the same instance of Future<bool> that will be returned by
        // internetConnectionChecker.hasConnection will the same instance that
        // will be returned by NetworkInfo.isConnected
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
