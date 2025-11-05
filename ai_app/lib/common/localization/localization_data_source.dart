import 'package:i18next/i18next.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocalizationDataSource)
class VisLocalizationDataSource extends AssetBundleLocalizationDataSource {
  VisLocalizationDataSource()
      : super(
          bundlePath: 'i18next',
        );
}
