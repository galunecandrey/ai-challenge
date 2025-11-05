abstract interface class DateTimeProvider {
  DateTime get current;

  Stream<DateTime> getDateChangedStream({bool sendFirst = false});

  Stream<DateTime> getTimeChangedStream({bool sendFirst = false});
}
