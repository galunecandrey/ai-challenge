
class ValueNotExistsException implements Exception {
  const ValueNotExistsException();
}

class EmptyStorageException implements Exception {
  const EmptyStorageException();
}

class NoSupportException implements Exception {
  const NoSupportException();
}

class NoConfigException implements Exception {
  const NoConfigException();
}

class NoSessionException implements Exception {
  const NoSessionException();
}

class NoUserException implements Exception {
  const NoUserException();
}

class NoRefreshTokenException implements Exception {
  const NoRefreshTokenException();
}

class NotAuthenticatedUserException implements Exception {
  const NotAuthenticatedUserException();
}

class ServiceDisposedException implements Exception {
  const ServiceDisposedException();
}

class StorageClosedException implements Exception {
  const StorageClosedException();
}
