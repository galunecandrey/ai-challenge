import 'package:vitals_sdk_example/common/utils/validator/regex_utils.dart';
import 'package:vitals_utils/vitals_utils.dart';

class StringValidator {
  static bool isUUID(String? value) => value != null && RegexUtils.isUUID(value);

  static bool isBase64(String? value) => value != null && RegexUtils.isBase64(value);

  static bool isFieldValid(String? value) => value != null && value.isNotBlank;

  static bool isEmpty(String? value) => value?.trim().isEmpty ?? true;

  static bool isMinMaxLengthValid(String? value, {required int minLength, required int maxLength}) {
    final length = value?.length ?? 0;
    return length >= minLength && length <= maxLength;
  }

  static bool isURL(String? value) => value != null && RegexUtils.isUrl(value);
}
