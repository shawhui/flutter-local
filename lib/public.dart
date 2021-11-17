import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';
import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/book_shelf_notify.dart';

//global
SharedPreferences preferences;
BookModelProvider bookModelProvider;
BookChapterModelProvider bookChapterModelProvider;
BookShelfNotify bookShelfNotify;



class SCColor {
  static Color primary = Color(0xFF23B38E);
  static Color secondary = Color(0xFF51DEC6);
  static Color red = Color(0xFFFF2B45);
  static Color orange = Color(0xFFF67264);
  static Color white = Color(0xFFFFFFFF);
  static Color paper = Color(0xFFF5F5F5);
  static Color lightGray = Color(0xFFEEEEEE);
  static Color darkGray = Color(0xFF333333);
  static Color gray = Color(0xFF888888);
  static Color blue = Color(0xFF3688FF);
  static Color golden = Color(0xff8B7961);

  static Color grayText = Color(0xff4A4A4A);
  static Color redText = Color(0xFFE66B08);

  static Color primaryText = Color(0xFF4A4A4A);
  static Color secondText = Color(0xFF9B9B9B);
  static Color lightText = Color(0xFF6380D5);

}


class FontPixel {

  static double p68 = 40;
  static double p64 = 36;
  static double p56 = 28;
  static double p48 = 24;
  static double p42 = 21;
  static double p40 = 20;
  static double p36 = 18;
  static double p32 = 16;
  static double p30 = 15;
  static double p28 = 14;
  static double p26 = 13;
  static double p24 = 12;
  static double p22 = 11;
  static double p20 = 10;
}


class Constants {

  static List<int> randomColor = [0xFFB0DEE2, 0xFFD8DFA8, 0xFFCAD4F2, 0xFFC6E8A0, 0xFFFBCACB, 0xFFDCC6EC,
    0xFFB9CBF0, 0xFFFFBCA0, 0xFFD2ECD5, 0xFFB7D9F4];

}


class Toast {
  static show(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}

class Styles {
  static List<BoxShadow> get borderShadow {
    return [BoxShadow(color: Color(0x22000000), blurRadius: 8)];
  }
}
