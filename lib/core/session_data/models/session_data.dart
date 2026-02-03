import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_data.freezed.dart';
part 'session_data.g.dart';

@freezed
sealed class SessionData with _$SessionData {
  const factory SessionData({
    required String email,
    required String password,
    String? token,
  }) = _SessionData;
  factory SessionData.fromJson(Map<String, dynamic> json) =>
      _$SessionDataFromJson(json);
}
