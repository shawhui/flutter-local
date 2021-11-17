import 'package:flutter_local_book/common.dart';
class ReaderConfig {

  static ReaderConfig _instance;
  static ReaderConfig get instance {
    if(_instance == null) {
      _instance = ReaderConfig();
    }
    return _instance;
  }

  double fontSize = 20.0;

  double topHeight = 38;

  double bottomHeight = 38;

  double paddingH = 14;
  double paddingV = 10;

  double get readHeight {
    return Screen.height - topHeight - bottomHeight;
  }

  double get readWidth {
    return Screen.width - paddingH*2;
  }

  double sectionSpace = 10;

  double chapterSpace = 24;

}