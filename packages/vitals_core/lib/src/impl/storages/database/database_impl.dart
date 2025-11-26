import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/database/dao/ai_session_dao.dart';
import 'package:vitals_core/src/api/storage/database/dao/embedding_dao.dart';
import 'package:vitals_core/src/api/storage/database/dao/messages_dao.dart' show MessagesDao;
import 'package:vitals_core/src/api/storage/database/database.dart' show Database;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, OperationService, Unit, right, unit;

@LazySingleton(as: Database, dispose: closeDatabase)
final class DatabaseImpl implements Database {
  String? _id;

  final MessagesDao _messages;

  final EmbeddingDao _embedding;

  final AISessionDao _session;

  final OperationService _operationService;

  DatabaseImpl(
    this._operationService,
    this._messages,
    this._session,
    this._embedding,
  );

  String _getTag(String method) => 'Database.$id.$method';

  @override
  String? get id => _id;

  @override
  Future<Either<BaseError, Unit>> close() {
    _id = null;
    return _operationService.safeUnitAsyncOp(
      () => Future.wait(
        [
          _session.close(),
          _messages.close(),
          _embedding.close(),
        ],
      ),
      tag: _getTag('close'),
    );
  }

  @override
  Future<Either<BaseError, Unit>> init([String? subDir]) {
    if (_id == subDir) {
      return Future.value(right(unit));
    }
    _id = subDir;
    return _operationService.safeUnitAsyncOp(
      () => Future.wait(
        [
          _session.init(subDir),
          _messages.init(subDir),
          _embedding.init(subDir),
        ],
      ),
      tag: _getTag('init'),
    );
  }

  @override
  Future<Either<BaseError, Unit>> clear() => _operationService.safeUnitAsyncOp(
        () => Future.wait(
          [
            _session.clear(),
            _messages.clear(),
            _embedding.clear(),
          ],
        ),
        tag: _getTag('clear'),
      );

  @override
  MessagesDao get messages => _messages;

  @override
  AISessionDao get session => _session;

  @override
  EmbeddingDao get embedding => _embedding;
}

FutureOr<dynamic> closeDatabase(Database db) => db.close();
