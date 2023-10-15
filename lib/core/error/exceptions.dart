class ServerException implements Exception {
  final int statusCode;
  final String message;

  const ServerException({
    required this.statusCode,
    required this.message,
  });
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    required this.message,
  });
}
