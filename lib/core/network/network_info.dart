import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker;

  NetworkInfoImpl({
    required InternetConnectionChecker internetConnectionChecker,
  }) : _internetConnectionChecker = internetConnectionChecker;

  // Using async-await in this method creates and returns a new instance of future of boolean
  // so the test will fail. To make it pass the test, I have to return directly
  // the same instance that the _internetConnectionChecker.hasConnection returns
  @override
  Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
}
