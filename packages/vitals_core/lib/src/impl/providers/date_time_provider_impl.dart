// ignore_for_file: close_sinks
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/api/providers/lifecycle_events_provider.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: DateTimeProvider)
class DateTimeProviderImpl extends Disposable implements DateTimeProvider {
  @override
  DateTime get current => DateTime.now();

  final LifecycleEventsProvider _lifecycleEventsProvider;
  late final StateStream<DateTime> _dateChanged = stateOf<DateTime>(current);
  late final StateStream<DateTime> _timeChanged = stateOf<DateTime>(current);
  late final StateStream<String> _timezone = stateOf<String>('UTC');

  DateTimeProviderImpl(
    this._lifecycleEventsProvider,
  ) {
    _lifecycleEventsProvider.appLifecycleState.listen((event) {
      if (event == AppLifecycleState.resumed) {
        if (!_dateChanged.value.isSameDay(current)) {
          _dateChanged.add(current);
        }
        if (_dateChanged.value != current) {
          _timeChanged.add(current);
        }
      }
    }).cancelable(cancelable);
  }

  @override
  Stream<DateTime> getDateChangedStream({bool sendFirst = false}) => _timezone(sendFirst: true)
      .distinct()
      .switchMap(
        (value) => _dateChanged(sendFirst: true),
      )
      .skip(sendFirst ? 0 : 1);

  @override
  Stream<DateTime> getTimeChangedStream({bool sendFirst = false}) => _timezone(sendFirst: true)
      .distinct()
      .switchMap(
        (value) => _timeChanged(sendFirst: true),
      )
      .skip(sendFirst ? 0 : 1);
}
