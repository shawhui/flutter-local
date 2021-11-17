// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSetting _$UserSettingFromJson(Map<String, dynamic> json) {
  return UserSetting(
    (json['fontSize'] as num)?.toDouble(),
    json['colorStyle'] as int,
    json['nightMode'] as bool,
    json['voiceSpeed'] as int,
    json['voiceStyle'] as int,
  );
}

Map<String, dynamic> _$UserSettingToJson(UserSetting instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'colorStyle': instance.colorStyle,
      'nightMode': instance.nightMode,
      'voiceSpeed': instance.voiceSpeed,
      'voiceStyle': instance.voiceStyle,
    };
