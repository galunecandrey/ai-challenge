import 'dart:typed_data';

import 'package:ksuid/ksuid.dart';
import 'package:uuid/uuid.dart';

extension StringExtension on String {
  String getKsuid(DateTime date) => KSUID.generate(date: date, payload: Uint8List.fromList(Uuid.parse(this))).asString;
}
