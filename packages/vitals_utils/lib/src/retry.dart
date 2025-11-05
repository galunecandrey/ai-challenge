typedef FutureGenerator<T> = Future<T> Function();

const kDefaultRetryDuration = Duration(milliseconds: 1000);

Future<T> retry<T>(
  FutureGenerator<T> aFuture, {
  int numberOfAttempts = 3,
  Duration delay = kDefaultRetryDuration,
}) async {
  try {
    return await aFuture();
  } catch (e) {
    if (numberOfAttempts > 1) {
      if (delay.inMicroseconds > 0) {
        await Future<dynamic>.delayed(delay);
      }
      return retry(
        aFuture,
        delay: delay,
        numberOfAttempts: numberOfAttempts - 1,
      );
    }
    rethrow;
  }
}
