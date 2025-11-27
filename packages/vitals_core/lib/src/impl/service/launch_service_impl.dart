import 'package:injectable/injectable.dart' show LazySingleton;
import 'package:open_dir/open_dir.dart' show OpenDir;
import 'package:path/path.dart';
import 'package:vitals_core/src/api/service/launch_service.dart' show LaunchService;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, ListExt, OperationService;

@LazySingleton(as: LaunchService)
class LaunchServiceImpl implements LaunchService {
  final OperationService _operationService;
  final OpenDir _openDir;

  LaunchServiceImpl(
    this._operationService,
    this._openDir,
  );

  String _getTag(String method) => 'LaunchService.$method';

  @override
  Future<Either<BaseError, bool>> launch(Uri uri) => _operationService.safeAsyncOp(
        () => _openDir
            .openNativeDir(
              path: '$separator${uri.pathSegments.filter((p) => p != uri.pathSegments.last).join(separator)}',
              highlightedFileName: uri.pathSegments.last,
            )
            .then(
              (v) => v ?? false,
            ),
        tag: _getTag('launch.$uri'),
      );
}
