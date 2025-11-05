import 'package:flutter/foundation.dart';

@immutable
class ErrorWithTag implements Exception {
  final String tag;
  final dynamic error;

  const ErrorWithTag({
    required this.tag,
    required this.error,
  });

  @override
  Type get runtimeType => error.runtimeType;

  @override
  String toString() => '$error\nTag: $tag';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ErrorWithTag && runtimeType == other.runtimeType && tag == other.tag && error == other.error;

  @override
  int get hashCode => tag.hashCode ^ error.hashCode;
}
