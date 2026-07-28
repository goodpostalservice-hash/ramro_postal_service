class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  const NoInternetException(super.message);
}

class TimeoutApiException extends ApiException {
  const TimeoutApiException(super.message);
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message);
}

class ValidationException extends ApiException {
  const ValidationException(super.message);
}

class ServerException extends ApiException {
  const ServerException(super.message);
}

class RequestCancelledException extends ApiException {
  const RequestCancelledException(super.message);
}
 