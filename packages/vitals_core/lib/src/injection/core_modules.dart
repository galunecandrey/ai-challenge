import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';

//ignore:depend_on_referenced_packages
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

@module
abstract class CoreModules {
  @lazySingleton
  LogPrinter get logPrinter => PrettyPrinter(
        dateTimeFormat: DateTimeFormat.dateAndTime,
        colors: false,
      );

  @lazySingleton
  Logger logger(
    LogFilter logFilter,
    LogPrinter logPrinter,
    LogOutput logOutput,
  ) =>
      Logger(
        filter: logFilter,
        printer: logPrinter,
        output: logOutput,
      );

  @lazySingleton
  PackageInfoPlatform get packageInfoPlatform => PackageInfoPlatform.instance;

  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @lazySingleton
  OpenAIClient openAIClient({@Named('AIKey') required String key}) => OpenAIClient(apiKey: key);

  @lazySingleton
  @Named('huggingfaceAIClient')
  OpenAIClient huggingfaceAIClient({@Named('huggingfaceAIKey') required String key}) => OpenAIClient(
        baseUrl: 'https://router.huggingface.co/v1',
        apiKey: key,
      );
}
