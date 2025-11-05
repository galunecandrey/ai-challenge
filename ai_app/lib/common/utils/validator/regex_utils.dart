import 'package:vitals_utils/vitals_utils.dart';

class RegexUtils {
  /// check if the string is a UUID (version 3, 4 or 5).
  static bool isUUID(String str, [int? version]) {
    final v = version?.toString() ?? 'all';

    final pat = _uuid[v];
    return pat != null && pat.hasMatch(str.toUpperCase());
  }

  /// check if a string is base64 encoded
  static bool isBase64(String str) => _base64.hasMatch(str);

  static String getInitials(String? fullName) => fullName != null && fullName.isNotBlank
      ? fullName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase()
      : '?';

  static bool isUrl(String url) => _url.hasMatch(url);
}

RegExp _url = RegExp(
  r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,7}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$",
);

RegExp _base64 = RegExp(
  r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$',
);

final Map<String, RegExp> _uuid = Map.unmodifiable({
  '3': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$'),
  '4': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
  '5': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
  'all': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$'),
});
