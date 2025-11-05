class TranslationVariables {
  static const kDate = 'date';
  static const kStartTime = 'start_time';
  static const kEndTime = 'end_time';
  static const kStartDate = 'start_date';
  static const kEndDate = 'end_date';
  static const kDuration = 'duration';
  static const kFirstName = 'first_name';
  static const kLastName = 'last_name';
  static const kGroup = 'group';
  static const kQueue = 'queue';
  static const kWeekDay = 'week_day';
  static const kInitiator = 'initiator';
  static const kUserFullName = 'user_full_name';
  static const kToggle = 'toggle';
  static const kInfo = 'info';
  static const kSupportNumber = 'support_number';
  static const kDeviceName = 'device_name';
  static const kVersion = 'version';
  static const kMessage = 'message';
  static const kQuote = 'quote';
  static const kField = 'field';
  static const kMin = 'min';
  static const kMax = 'max';
  static const kDay = 'day';
  static const kDays = 'days';
  static const kInterval = 'interval';
  static const kStartingTime = 'starting_time';
  static const kError = 'error';

  Map<String, Object?> variables = {};

  TranslationVariables({
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? startDate,
    DateTime? endDate,
    Duration? duration,
    String? firstName,
    String? lastName,
    String? group,
    String? queue,
    String? initiator,
    String? userFullName,
    String? toggle,
    String? info,
    String? supportNumber,
    String? deviceName,
    String? version,
    String? message,
    String? quote,
    String? field,
    int? min,
    int? max,
    int? day,
    int? weekDay,
    String? days,
    int? interval,
    DateTime? startingTime,
    Object? error,
  }) {
    if (date != null) {
      variables[kDate] = date;
    }
    if (startTime != null) {
      variables[kStartTime] = startTime;
    }
    if (endTime != null) {
      variables[kEndTime] = endTime;
    }
    if (startDate != null) {
      variables[kStartDate] = startDate;
    }
    if (endDate != null) {
      variables[kEndDate] = endDate;
    }
    if (duration != null) {
      variables[kDuration] = duration;
    }
    if (firstName != null) {
      variables[kFirstName] = firstName;
    }
    if (lastName != null) {
      variables[kLastName] = lastName;
    }
    if (userFullName != null) {
      variables[kUserFullName] = userFullName;
    }
    if (group != null) {
      variables[kGroup] = group;
    }
    if (queue != null) {
      variables[kQueue] = queue;
    }
    if (weekDay != null) {
      variables[kWeekDay] = weekDay;
    }
    if (initiator != null) {
      variables[kInitiator] = initiator;
    }
    if (toggle != null) {
      variables[kToggle] = toggle;
    }
    if (info != null) {
      variables[kInfo] = info;
    }
    if (supportNumber != null) {
      variables[kSupportNumber] = supportNumber;
    }
    if (deviceName != null) {
      variables[kDeviceName] = deviceName;
    }
    if (version != null) {
      variables[kVersion] = version;
    }
    if (message != null) {
      variables[kMessage] = message;
    }
    if (quote != null) {
      variables[kQuote] = quote;
    }
    if (field != null) {
      variables[kField] = field;
    }
    if (min != null) {
      variables[kMin] = min;
    }
    if (max != null) {
      variables[kMax] = max;
    }
    if (day != null) {
      variables[kDay] = day;
    }
    if (days != null) {
      variables[kDays] = days;
    }
    if (interval != null) {
      variables[kInterval] = interval;
    }
    if (startingTime != null) {
      variables[kStartingTime] = startingTime;
    }
    if (error != null) {
      variables[kError] = error.toString();
    }
  }
}
