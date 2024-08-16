enum GlobalException {
  genericUnauthorized,
  genericInternalError,
  genericUnavailableService,
  genericNoContent
}

extension GlobalExceptionExtension on GlobalException {
  String get message {
    switch (this) {
      case GlobalException.genericNoContent:
        return 'No content!';
      case GlobalException.genericUnauthorized:
        return 'Request unauthorized, try again!';
      case GlobalException.genericInternalError:
        return 'Request internal error, try again!';
      case GlobalException.genericUnavailableService:
        return 'Service unavailable, try again!';
      default:
        return 'Message not found!';
    }
  }
}
