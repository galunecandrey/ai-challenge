import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:vitals_core/src/utils/const/hive.dart' show HiveEntities;

part 'ai_session.freezed.dart';

part 'ai_session.g.dart';

@freezed
sealed class AISession with _$AISession {
  @HiveType(typeId: HiveEntities.kSessions, adapterName: 'AISessionAdapter')
  const factory AISession({
    @HiveField(0) required String key,
    @HiveField(1) String? name,
    @HiveField(2) String? systemPrompt,
    @HiveField(3, defaultValue: 'gpt-5') @Default('gpt-5') String model,
  }) = _AISession;

  factory AISession.fromJson(Map<String, dynamic> json) => _$AISessionFromJson(json);
}
