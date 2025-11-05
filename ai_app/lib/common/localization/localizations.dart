import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';

//ignore: implementation_imports
import 'package:i18next/src/translator.dart';
import 'package:intl/intl.dart' show DateFormat, Intl, NumberFormat;
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart' as core;
import 'package:vitals_sdk_example/common/localization/translation_variables.dart';
import 'package:vitals_sdk_example/common/utils/ext/date_extension.dart';
import 'package:vitals_utils/vitals_utils.dart' as utils;

const enLanguage = Locale('en', 'US');

const defaultLanguage = enLanguage;
const List<Locale> supportedLocales = [
  enLanguage,
];

class HomeTranslationKeys {
  static const kNamespace = LocalizationNamespace.home;

  //Home
  static const kDeviceID = 'DEVICE_ID';
  static const kDevicePin = 'DEVICE_PIN';
  static const kDevicePORT = 'DEVICE_PORT';
  static const kAppointmentID = 'APPOINTMENT_ID';
  static const kConnectBtn = 'CONNECT_BTN';
  static const kDisconnectBtn = 'DISCONNECT_BTN';
  static const kStartBtn = 'START_BTN';
  static const kStopBtn = 'STOP_BTN';
  static const kHomeErrorMsgInvalidAppointmentID = 'HOME_ERROR_MSG_INVALID_APPOINTMENT_ID';
  static const kTrendsDataPeriodTitle = 'TRENDS_DATA_PERIOD_TITLE';
  static const kTrendsDataPeriodValue = 'TRENDS_DATA_PERIOD_VALUE';
  static const kRenderingQualityTitle = 'RENDERING_QUALITY_TITLE';
  static const kRenderingQualityLow = 'RENDERING_QUALITY_LOW';
  static const kRenderingQualityMedium = 'RENDERING_QUALITY_MEDIUM';
  static const kRenderingQualityHigh = 'RENDERING_QUALITY_HIGH';
  static const kRenderingOrientationTitle = 'RENDERING_ORIENTATION_TITLE';
  static const kRenderingOrientationLandscape = 'RENDERING_ORIENTATION_LANDSCAPE';
  static const kRenderingOrientationPortrait = 'RENDERING_ORIENTATION_PORTRAIT';
}

class AuthTranslationKeys {
  static const kNamespace = LocalizationNamespace.auth;

  //Login
  static const kLoginTitle = 'LOGIN_TITLE';
  static const kLoginFieldNameBaseURL = 'LOGIN_FIELD_NAME_BASE_URL';
  static const kLoginFieldHintBaseURL = 'LOGIN_FIELD_HINT_BASE_URL';
  static const kLoginFieldNameApiKey = 'LOGIN_FIELD_NAME_API_KEY';
  static const kLoginFieldHintApiKey = 'LOGIN_FIELD_HINT_API_KEY';
  static const kLoginFieldNameClientKey = 'LOGIN_FIELD_NAME_CLIENT_KEY';
  static const kLoginFieldHintClientKey = 'LOGIN_FIELD_HINT_CLIENT_KEY';
  static const kLoginFieldNameSecret = 'LOGIN_FIELD_NAME_SECRET';
  static const kLoginFieldHintSecret = 'LOGIN_FIELD_HINT_SECRET';
  static const kLoginBtnSignIn = 'LOGIN_BTN_SIGN_IN';
  static const kLoginBtnSignInAsGuest = 'LOGIN_BTN_SIGN_IN_AS_GUEST';
  static const kLoginErrorMsgInvalidBaseURL = 'LOGIN_ERROR_MSG_INVALID_BASE_URL';
  static const kLoginErrorMsgInvalidApiKey = 'LOGIN_ERROR_MSG_INVALID_API_KEY';
  static const kLoginErrorMsgInvalidClientKey = 'LOGIN_ERROR_MSG_INVALID_CLIENT_KEY';
  static const kLoginErrorMsgInvalidSecret = 'LOGIN_ERROR_MSG_INVALID_SECRET';
  static const kLoginErrorMsgInvalidCredentials = 'LOGIN_ERROR_MSG_INVALID_CREDENTIALS';
}

class CommonTranslationKeys {
  static const kNamespace = LocalizationNamespace.common;

  //Common
  static const kGlobalAppName = 'GLOBAL_APP_NAME';
  static const kGlobalErrorMsgInit = 'GLOBAL_ERROR_MSG_INIT';
  static const kGlobalBtnSubmit = 'GLOBAL_BTN_SUBMIT';
  static const kGlobalBtnOk = 'GLOBAL_BTN_OK';
  static const kGlobalBtnCancel = 'GLOBAL_BTN_CANCEL';
  static const kGlobalBtnClose = 'GLOBAL_BTN_CLOSE';
  static const kGlobalBtnBack = 'GLOBAL_BTN_BACK';
  static const kGlobalErrorTitleGeneric = 'GLOBAL_ERROR_TITLE_GENERIC';
  static const kGlobalErrorMsgGeneric = 'GLOBAL_ERROR_MSG_GENERIC';
  static const kkGlobalErrorMsgWithError = 'GLOBAL_ERROR_MSG_WITH_ERROR';
}

String formatter(Object value, String? format, Locale locale) {
  switch (format) {
    case 'uppercase':
      return value.toString().toUpperCase();
    case 'lowercase':
      return value.toString().toLowerCase();
    case 'translation':
      return value.toString().isNotEmpty ? '\$t($value)' : '';
    default:
      if (format == null) {
        return value.toString();
      } else if (value is DateTime) {
        if (format == 'EEEEE') {
          return DateFormat('EEE', locale.toString()).format(value).substring(0, 1);
        } else if (format.contains('TODAY_TIME')) {
          final is12HoursFormat = !getIt<core.PlatformProvider>().is24TimeFormat;
          final isMidnight = value.isMidnight(DateTime.now());
          if (is12HoursFormat) {
            final formattedDate = DateFormat(
              'jm',
              locale.toString(),
            ).format(value);
            return isMidnight ? formattedDate.replaceBefore(':', '12') : formattedDate;
          }

          final formattedDate = DateFormat(
            'HH:mm',
            locale.toString(),
          ).format(value);

          return isMidnight ? formattedDate.replaceBefore(':', '24') : formattedDate;
        } else if (format.contains('H:mm')) {
          final is12HoursFormat = !getIt<core.PlatformProvider>().is24TimeFormat;

          if (is12HoursFormat) {
            return DateFormat(
              format.replaceAll('HH:mm', 'jm').replaceAll('H:mm', 'jm').replaceAll(':ss', 's'),
              locale.toString(),
            ).format(value);
          } else if (!format.contains('HH:mm')) {
            return DateFormat(
              format.replaceAll('H:', 'HH:'),
              locale.toString(),
            ).format(value);
          }
        }
        return DateFormat(format, locale.toString()).format(value);
      } else if (value is Duration) {
        final startPoint = DateTime(0, 0, 0);
        final date = startPoint.add(value);
        return DateFormat(format, locale.toString()).format(date);
      } else if (value is num) {
        if (value is int && format == 'EEEE') {
          final withWeekDay = DateTime.now().setWeekDay(value);
          return DateFormat(format, locale.toString()).format(withWeekDay);
        } else if (value is int && format == 'UTC') {
          return "(UTC${value >= 0 ? '+' : ''}$value:00)";
        }
        return NumberFormat(format).format(value);
      }
  }
  return value.toString();
}

enum LocalizationNamespace {
  common('common'),
  auth('auth'),
  home('home');

  final String stringValue;

  const LocalizationNamespace(this.stringValue);
}

enum LocalizationGender {
  male('male'),
  female('female');

  final String stringValue;

  const LocalizationGender(this.stringValue);
}

extension BuildContextExt on BuildContext {
  String translate(
    String key, {
    LocalizationNamespace namespace = LocalizationNamespace.common,
    int? count,
    LocalizationGender? gender,
    TranslationVariables? variables,
  }) {
    final i18Next = I18Next.of(this)!;
    var resolvedKey = key;

    if (count != null) {
      resolvedKey = _getResolvedPluralKey(count, i18Next, key);
    }

    return i18Next.t(
      '${namespace.stringValue}:$resolvedKey',
      count: count,
      context: gender?.stringValue,
      variables: variables?.variables,
    );
  }
}

enum PluralType {
  zero,
  one,
  two,
  few,
  many,
  other,
}

extension PluralTypeExtension on PluralType {
  String get pluralSuffix => '_${name.toUpperCase()}';
}

String _getResolvedPluralKey(int count, I18Next i18Next, String key) => Intl.plural(
      count,
      zero: _getPluralKeyFromPluralType(PluralType.zero, i18Next, key),
      one: _getPluralKeyFromPluralType(PluralType.one, i18Next, key),
      two: _getPluralKeyFromPluralType(PluralType.two, i18Next, key),
      few: _getPluralKeyFromPluralType(PluralType.few, i18Next, key),
      many: _getPluralKeyFromPluralType(PluralType.many, i18Next, key),
      other: _getPluralKeyFromPluralType(PluralType.other, i18Next, key) ?? key,
      locale: i18Next.locale.languageCode,
    );

String? _getPluralKeyFromPluralType(
  PluralType pluralType,
  I18Next i18Next,
  String key,
) =>
    i18Next.translationKey('$key${pluralType.pluralSuffix}');

extension StateExt on State {
  String translate(
    String key, {
    LocalizationNamespace namespace = LocalizationNamespace.common,
    int? count,
    LocalizationGender? gender,
    TranslationVariables? variables,
  }) =>
      context.translate(
        key,
        namespace: namespace,
        count: count,
        gender: gender,
        variables: variables,
      );
}

extension I18NextExtension on I18Next {
  String? translationKey(String key) {
    final translatedKey = Translator(pluralResolver, resourceStore).translateKey(
      locale,
      '',
      key,
      <String, dynamic>{},
      options,
    );

    return translatedKey == null ? null : key;
  }
}
