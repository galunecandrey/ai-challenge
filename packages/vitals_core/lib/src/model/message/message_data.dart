// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_data.freezed.dart';
part 'message_data.g.dart';

@freezed
sealed class MessageData with _$MessageData {
  @JsonSerializable(explicitToJson: true)
  const factory MessageData({
    required String tag,
    required String title,
    required String answer,
    required DateTime time,
  }) = _MessageData;

  factory MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);
}
