import 'package:flutter_udid/flutter_udid.dart' show FlutterUdid;
import 'package:injectable/injectable.dart';
import 'package:ksuid/ksuid.dart' show KSUID;
import 'package:vitals_core/src/api/providers/device_id_provider.dart' show DeviceIdProvider;
import 'package:vitals_core/src/api/providers/platform_provider.dart' show PlatformProvider;
import 'package:vitals_utils/vitals_utils.dart' show OperationService;

@LazySingleton(as: DeviceIdProvider)
class DeviceIdProviderImpl implements DeviceIdProvider {
  final OperationService _operationService;
  final PlatformProvider _platformProvider;
  final KSUID _ksuid;

  DeviceIdProviderImpl(
    this._operationService,
    this._platformProvider,
    this._ksuid,
  );

  String _getTag(String method) => 'DeviceIdProvider.$method';

  @override
  Future<String> get deviceId => _operationService
      .safeAsyncOp(
        () => FlutterUdid.udid,
        shouldTrackLog: false,
        tag: _getTag('deviceId'),
      )
      .then(
        (value) => value.fold(
          (l) => _buildDeviceId(_ksuid.asString),
          (r) => _buildDeviceId(r.isNotEmpty ? r : _ksuid.asString),
        ),
      );

  String _buildDeviceId(String id) => '${_platformProvider.platformInfo.platform.name}:$id';
}
