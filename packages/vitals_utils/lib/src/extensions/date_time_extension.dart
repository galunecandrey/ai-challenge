import 'package:vitals_utils/src/date.dart';

extension DateTimeExtension on DateTime {
  bool isBetween(DateTime from, DateTime to) => !isDateBefore(from) && !isDateAfter(to);

  bool isTimeBetween(DateTime from, DateTime to) => !isBefore(from) && !isAfter(to);

  bool isPastDay(DateTime now) => isBefore(now.copyTime(this));

  bool isSameTime(DateTime other) => hour == other.hour && minute == other.minute && second == other.second;

  bool isSameMonthAndYear(DateTime other) => year == other.year && month == other.month;

  bool isTomorrow(DateTime now) => isAfter(
        now.copyWith(
          hour: 23,
          minute: 59,
          second: 59,
        ),
      );

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        millisecond ?? this.microsecond,
      );

  DateTime copyDateOnly({int? year, int? month, int? day}) => DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
      );

  DateTime copyTime(DateTime time) => copyWith(
        hour: time.hour,
        minute: time.minute,
        second: time.second,
        millisecond: time.millisecond,
        microsecond: time.microsecond,
      );

  DateTime copyDate(DateTime date) => copyWith(
        year: date.year,
        month: date.month,
        day: date.day,
      );

  DateTime copyAsUtc() => DateTime.utc(year, month, day, hour, minute, second);

  int diffInDays(DateTime to) {
    final fromDate = DateTime(year, month, day);
    final toDate = DateTime(to.year, to.month, to.day);
    return (toDate.difference(fromDate).inHours / 24).round();
  }

  int diffInMinutes(DateTime to) => ((to.millisecondsSinceEpoch - millisecondsSinceEpoch) / 1000 / 60).round();

  int diffInHours(DateTime to) => (diffInMinutes(to) / 60).round();

  bool isDateAfter(DateTime date) => diffInDays(date) < 0;

  bool isDateBefore(DateTime date) => diffInDays(date) > 0;

  int compareTime(DateTime time) {
    if (isSameTime(time)) {
      return 0;
    }

    if (hour != time.hour) {
      return hour > time.hour ? 1 : -1;
    }

    if (minute != time.minute) {
      return minute > time.minute ? 1 : -1;
    }

    if (second != time.second) {
      return second > time.second ? 1 : -1;
    }

    return 0;
  }

  DateTime roundUp({Duration delta = const Duration(seconds: 15)}) =>
      add(Duration(milliseconds: delta.inMilliseconds - (millisecondsSinceEpoch % delta.inMilliseconds))).copyWith(
        millisecond: 0,
        microsecond: 0,
      );

  (DateTime, DateTime) getWeekRange() => (
        subtract(Duration(days: weekday - 1)),
        add(Duration(days: DateTime.daysPerWeek - weekday)),
      );

  (DateTime, DateTime) getMonthRange() => (
        DateTime(year, month),
        DateTime(month < 12 ? year : year + 1, month < 12 ? month + 1 : 1).subMilliseconds(1),
      );
}

extension IntNullableExtension on int? {
  DateTime? get dateTimeFromUnixNullable => this != null ? DateTime.fromMillisecondsSinceEpoch(this! * 1000) : null;
}

extension IntExtension on int {
  DateTime get dateTimeFromUnix => DateTime.fromMillisecondsSinceEpoch(this * 1000);

  DateTime get dateTimeFromUnixUtc => DateTime.fromMillisecondsSinceEpoch(this * 1000, isUtc: true);
}

extension IntStreamExtension on Stream<int> {
  Stream<DateTime> get dateTimeStream => map((event) => event.dateTimeFromUnix);
}
