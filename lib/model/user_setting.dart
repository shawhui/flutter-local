import 'package:json_annotation/json_annotation.dart';

part 'user_setting.g.dart';


@JsonSerializable()
class UserSetting extends Object {

  @JsonKey(name: 'fontSize')
  double fontSize;

  @JsonKey(name: 'colorStyle')
  int colorStyle;

  @JsonKey(name: 'nightMode')
  bool nightMode;

  @JsonKey(name: 'voiceSpeed')
  int voiceSpeed;

  @JsonKey(name: 'voiceStyle')
  int voiceStyle;

  UserSetting(this.fontSize,this.colorStyle,this.nightMode,this.voiceSpeed,this.voiceStyle,);

  factory UserSetting.fromJson(Map<String, dynamic> srcJson) => _$UserSettingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserSettingToJson(this);

}

  
