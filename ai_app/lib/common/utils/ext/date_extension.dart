import 'package:intl/intl.dart';
import 'package:vitals_utils/vitals_utils.dart';

const kHhMMFormat = 'HH:mm';

extension DateExtension on DateTime {
  DateTime setWeekDay(int weekday, [int weekStartsOn = DateTime.sunday]) {
    const daysPerWeek = DateTime.daysPerWeek;
    final currentDay = this.weekday;
    final reminder = weekday % daysPerWeek;
    final dayIndex = (reminder + daysPerWeek) % daysPerWeek;
    final delta = daysPerWeek - weekStartsOn;
    final diff = weekday < 0 || weekday > 6
        ? weekday - ((currentDay + delta) % daysPerWeek)
        : ((dayIndex + delta) % daysPerWeek) - ((currentDay + delta) % daysPerWeek);

    return addDays(diff);
  }

  String get timeFormat => DateFormat(kHhMMFormat).format(this);

  String getTimeFormatWithMidnight(DateTime current) {
    final formattedDate = DateFormat(kHhMMFormat).format(this);

    return isMidnight(current) ? formattedDate.replaceBefore(':', '24') : formattedDate;
  }

  bool isMidnight(DateTime current) => !isToday(current) && hour == 0 && minute == 0;
}
