// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_data.freezed.dart';

part 'usage_data.g.dart';

@freezed
sealed class UsageData with _$UsageData {
  @JsonSerializable(explicitToJson: true)
  const factory UsageData({
    int? requestTokens,
    int? responseTokens,
    int? totalTokens,
    Duration? time,
  }) = _UsageData;

  factory UsageData.fromJson(Map<String, dynamic> json) => _$UsageDataFromJson(json);
}
