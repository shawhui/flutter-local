import 'dart:convert';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/model/user_setting.dart';


class SettingManager {
  static SettingManager _instance;

  static SettingManager get instance {
    if (_instance == null) {
      _instance = SettingManager();
    }
    return _instance;
  }

  UserSetting setting;
  static UserSetting get getUserSetting {
    return SettingManager.instance.setting;
  }

  init() {
    String settingJson = preferences.getString('setting');
    if (settingJson != null) {
      setting = UserSetting.fromJson(json.decode(settingJson));
    } else {
      setting = UserSetting(20, -1, false, 5, 0);
      preferences.setString('setting', json.encode(setting));
    }
  }

  update() {
    preferences.setString('setting', json.encode(setting));
  }

  double getFontSize() {
    return setting.fontSize;
  }

  int getFontBackGround() {

    if(setting.nightMode) {
      return 0xFF000000;
    }

    if(setting.colorStyle == -1) {
      return 0xFFFFFFFF;
    }
    List<int> colors = getBackgroundColors();
    return colors[setting.colorStyle];
  }

  int getFontColor() {

    if(setting.nightMode) {
      return 0xFF9B9B9BF;
    }

    if(setting.colorStyle == -1) {
      return 0xFF4A4A4A;
    }
    List<int> colors = [0xFF222A20, 0xFF2A2320, 0xFF1F223F, 0xFF1F223F, 0xFF1F223F];
    return colors[setting.colorStyle];
  }

  List<int> getBackgroundColors() {
    return  [0xFFCAD6BA, 0xFFF3D6C4, 0xFFC6DDE2, 0xFFC7D0EA, 0xFFB3E6E6];
  }

  int getSettingBackground() {
    if(setting.nightMode) {
      return 0xFF000000;
    }

    if(setting.colorStyle == -1) {
      return 0xFFF2F2F2;
    }

    return [0xFFF3FFE3, 0xFFF6EFEB, 0xFFEAFFFF, 0xFFE2E9FF, 0xFFE1FFFF][setting.colorStyle];

  }

  int getSettingButton() {
    if(setting.nightMode) {
      return 0xFF1C4E37;
    }

    if(setting.colorStyle == -1) {
      return 0xFF333233;
    }
    List<int> colors = [0xFFF3FFE3, 0xFFF6EFEB, 0xFFEAFFFF, 0xFFE2E9FF, 0xFFE1FFFF];
    return colors[setting.colorStyle];
  }

  int getStyle() {
    return setting.colorStyle;
  }

  int getFontLightColor() {
    if(setting.nightMode) {
      return 0xFF1C4E37;
    }

    if(setting.colorStyle == -1) {
      return 0xFFE1EAFF;
    }
    List<int> colors = [0xFFAFC495, 0xFFE4BBA1, 0xFF9DC9D3, 0xFFA5B3DE, 0xFF81C8C8];
    return colors[setting.colorStyle];
  }

  void switchNightMode() {
    setting.nightMode = !setting.nightMode;
  }

  int getTitleFontColor() {
    if(setting.nightMode) {
      return 0xFF6C6C6C;
    }

    if(setting.colorStyle == -1) {
      return 0xFFAEB1C0;
    }
    List<int> colors = [0xFF98B17F, 0xFFAF837B, 0xFF698EA2, 0xFF738ACA, 0xFF698EA2];
    return colors[setting.colorStyle];
  }

}
