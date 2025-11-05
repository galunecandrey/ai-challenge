import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_utils/vitals_utils.dart';

@lazySingleton
class Initializer {
  late final _completer = Completer<bool>();

  bool isInitialized = false;

  String _getTag(String method) => 'Initializer.$method';

  Initializer(GetIt di, OperationService os) {
    _startOperation(di, os);
  }

  bool get isCompleted => _completer.isCompleted;

  bool get isReady => isCompleted && isInitialized;

  Future<bool> get wait => _completer.future;

  Future<void> _startOperation(GetIt di, OperationService os) async {
    final result = await os.safeAsyncOp(
      () => di.allReady(),
      tag: _getTag('startOperation'),
    );
    _setResult(
      result.isRight(),
    );
  }

  void _setResult(bool result) {
    isInitialized = result;
    _completer.complete(
      result,
    );
  }
}
