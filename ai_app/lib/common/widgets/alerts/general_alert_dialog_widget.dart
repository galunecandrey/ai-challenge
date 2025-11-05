import 'package:flutter/cupertino.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/common/localization/translation_variables.dart';

class GeneralAlertDialog extends StatelessWidget {
  final String? titleTextKey;
  final String? okButtonTextKey;
  final String? descriptionTextKey;
  final String? cancelButtonTextKey;
  final String? descriptionText;
  final bool isMainActionDestructive;
  final Object? error;

  const GeneralAlertDialog({
    this.okButtonTextKey,
    this.titleTextKey,
    this.descriptionTextKey,
    this.cancelButtonTextKey,
    this.descriptionText,
    this.isMainActionDestructive = false,
    this.error,
    super.key,
  })  : assert(titleTextKey != null || descriptionTextKey != null || descriptionText != null),
        assert(descriptionText == null || descriptionTextKey == null);

  @override
  Widget build(BuildContext context) => CupertinoAlertDialog(
        title: titleTextKey != null
            ? Text(
                context.translate(
                  titleTextKey!,
                ),
              )
            : null,
        content: descriptionTextKey != null || descriptionText != null
            ? Text(
                descriptionText ??
                    context.translate(
                      descriptionTextKey!,
                      variables: TranslationVariables(error: error),
                    ),
              )
            : null,
        actions: <Widget>[
          if (cancelButtonTextKey != null)
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                context.translate(
                  cancelButtonTextKey!,
                ),
              ),
            ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            isDestructiveAction: isMainActionDestructive,
            child: Text(
              context.translate(
                okButtonTextKey ?? CommonTranslationKeys.kGlobalBtnOk,
              ),
            ),
          ),
        ],
      );
}
