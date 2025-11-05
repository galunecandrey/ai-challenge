import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/utils/const/formatter.dart';
import 'package:vitals_core/src/utils/const/log_file.dart';
import 'package:vitals_utils/vitals_utils.dart';

const kFlutterLogsLifecycleDuration = Duration(days: 3);
const kReportLogsLifecycleDuration = Duration(hours: 1);
const kSDKLogsLifecycleDuration = Duration(hours: 2);

@LazySingleton(as: LogFilter)
class VitalsLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

@LazySingleton(as: LogOutput)
class VitalsLogOutput extends LogOutput {
  final DateTimeProvider _dateTimeProvider;
  final Directory _dir;
  late final Directory logDir;
  late DateTime _dateTime;
  late File _file;

  VitalsLogOutput(
    this._dir,
    this._dateTimeProvider,
  ) {
    logDir = Directory(join(_dir.path, 'log'));
    if (!logDir.existsSync()) {
      logDir.createSync();
    }
    _createFile(_dateTimeProvider.current);
  }

  @override
  void output(OutputEvent event) {
    _checkFile();
    for (final e in event.lines) {
      _file.writeAsStringSync(
        '\n$e',
        mode: FileMode.writeOnlyAppend,
      );
    }
  }

  void _createFile(DateTime current) {
    _dateTime = current;
    _file = File(join(logDir.path, '$kFlutterLogPrefix${kSimpleDateFormatter.format(_dateTime)}.txt'));
    _cleanLogs(_dir, _dateTimeProvider);
  }

  void _checkFile() {
    final now = _dateTimeProvider.current;
    if (!now.isSameDay(_dateTime)) {
      _createFile(now);
    }
  }

  void _cleanLogs(
    Directory directory,
    DateTimeProvider dateTimeProvider,
  ) {
    final date = dateTimeProvider.current.millisecondsSinceEpoch;
    _cleanLogsDir(
      Directory(join(directory.path, 'log')),
      date,
      kSimpleDateFormatter,
      kFlutterLogPrefix,
      kFlutterLogsLifecycleDuration,
    );
  }

  Future<void> _cleanLogsDir(
    Directory logDir,
    int date,
    DateFormat formatter,
    String prefix,
    Duration duration,
  ) async {
    if (logDir.existsSync()) {
      final files = logDir.listSync();
      for (final file in files) {
        try {
          final diff = date -
              formatter
                  .parse(
                    file.uri.pathSegments.last.split('.').first.removePrefix(prefix),
                  )
                  .millisecondsSinceEpoch;
          if (diff > duration.inMilliseconds) {
            await file.delete(recursive: true);
          }
        } catch (e) {
          await file.delete(recursive: true);
        }
      }
    }
  }
}
