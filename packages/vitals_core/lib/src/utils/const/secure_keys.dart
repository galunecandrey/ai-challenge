import 'package:vitals_core/src/utils/const/dao.dart' show DaoClasses;
import 'package:vitals_core/src/utils/const/realm.dart' show kRealmName;

class SecureKeys {
  static const kDeviceId = 'device_id$_kSecureKey';
  static const kSessions = '${DaoClasses.kSessions}$_kSecureKey';
  static const kRealm = '$kRealmName$_kSecureKey';
}

const _kSecureKey = '_secure_key';
