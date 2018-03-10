class NetworkException implements Exception {
  String cause;
  Exception origin;
  NetworkException(this.cause) {
    print(this.cause);
  }
  NetworkException.withOrigin(this.cause, this.origin) {
    print(this.cause);
    print(this.origin);
  }
}