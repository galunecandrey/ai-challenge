extension StringNullableExt on String? {
  String get orEmpty => this ?? '';

  bool get isNullOrBlank => this?.isBlank ?? true;

  bool get isNullOrEmpty => this?.isEmpty ?? true;
}

extension StringUsefulExt on String {
  Iterable<int> get indices sync* {
    for (var i = 0; i < length; ++i) {
      yield i;
    }
  }

  bool get isBlank => length == 0 || isEmpty || indices.every((index) => this[index] == ' ' || this[index] == '');

  bool get isNotBlank => !isBlank;

  /// check if a string is base64 encoded
  bool get isBase64 => !isEmpty && _base64.hasMatch(this);

  /// check if a string is email
  bool get isEmail => !isEmpty && _email.hasMatch(this);

  String ifEmpty(String Function() defaultValue) => isEmpty ? defaultValue() : this;

  String ifBlank(String Function() defaultValue) => isBlank ? defaultValue() : this;

  int get lastIndex => length - 1;

  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalizeAll => split(' ').map((str) => str.capitalize).join(' ');

  String substringBefore(String delimiter, {String? missingDelimiterValue}) {
    final index = indexOf(delimiter);
    return index < 0 ? missingDelimiterValue ?? this : substring(0, index);
  }

  String substringAfter(String delimiter, {String? missingDelimiterValue}) {
    final index = indexOf(delimiter);
    return index < 0 ? missingDelimiterValue ?? this : substring(index + 1, length);
  }

  String substringBeforeLast(String delimiter, {String? missingDelimiterValue}) {
    final index = lastIndexOf(delimiter);
    return index < 0 ? missingDelimiterValue ?? this : substring(0, index);
  }

  String substringAfterLast(String delimiter, {String? missingDelimiterValue}) {
    final index = lastIndexOf(delimiter);
    return index < 0 ? missingDelimiterValue ?? this : substring(index + 1, length);
  }

  String removeRange(int startIndex, int endIndex) {
    if (endIndex <= startIndex) {
      return this;
    }
    final strBuilder = StringBuffer()..writeAll(<String>[substring(0, startIndex), substring(endIndex, length)]);
    return strBuilder.toString();
  }

  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length);
    }
    return this;
  }

  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }

  String removeSurrounding(String prefix, String suffix) {
    if ((length >= prefix.length + suffix.length) && startsWith(prefix) && endsWith(suffix)) {
      return substring(prefix.length, length - suffix.length);
    }
    return this;
  }

  String replaceBefore(String delimiter, String replacement, [String? missingDelimiterValue]) {
    missingDelimiterValue ??= this;
    final index = indexOf(delimiter);
    return index < 0 ? missingDelimiterValue : replaceRange(0, index, replacement);
  }

  String replaceAfter(String delimiter, String replacement, [String? missingDelimiterValue]) {
    missingDelimiterValue ??= this;
    final index = indexOf(delimiter);
    return index < 0 ? missingDelimiterValue : replaceRange(index + delimiter.length, length, replacement);
  }

  String replaceAfterLast(String delimiter, String replacement, [String? missingDelimiterValue]) {
    missingDelimiterValue ??= this;
    final index = lastIndexOf(delimiter);
    return index < 0 ? missingDelimiterValue : replaceRange(index + index + delimiter.length, length, replacement);
  }

  String replaceBeforeLast(String delimiter, String replacement, [String? missingDelimiterValue]) {
    missingDelimiterValue ??= this;
    final index = lastIndexOf(delimiter);
    return index < 0 ? missingDelimiterValue : replaceRange(0, index, replacement);
  }

  String trimAll() => trim().replaceAll('\\s+'.regExp, ' ');

  RegExp get regExp => RegExp(this);

  RegExp toRegExp({bool multiLine = false, bool caseSensitive = true, bool unicode = false, bool dotAll = false}) =>
      RegExp(
        this,
        multiLine: multiLine,
        caseSensitive: caseSensitive,
        unicode: unicode,
        dotAll: dotAll,
      );
}

RegExp _email =
    r"[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        .regExp;

RegExp _base64 = r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$'.regExp;
