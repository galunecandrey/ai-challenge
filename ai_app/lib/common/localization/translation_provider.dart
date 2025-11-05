import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/common/localization/translation_variables.dart';
import 'package:vitals_sdk_example/router/router.dart';

typedef ContextFun = BuildContext Function();

@lazySingleton
class TranslationProvider {
  final ContextFun _contextFun;

  TranslationProvider(VitalsRouter router) : _contextFun = (() => router.currentContext);

  String translate(
    String key, {
    LocalizationNamespace namespace = LocalizationNamespace.common,
    int? count,
    LocalizationGender? gender,
    TranslationVariables? variables,
  }) =>
      _contextFun().translate(
        key,
        namespace: namespace,
        count: count,
        gender: gender,
        variables: variables,
      );
}
