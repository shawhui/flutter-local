import 'screen.dart';
import 'package:flutter_local_book/public.dart';
import 'dart:math';


fixedFontSize(double fontSize) {
  return fontSize / Screen.textScaleFactor;
}

bool listEmpty(List list) {
  return list == null || list.isEmpty;
}

bool listNotEmpty(List list) {
  return !listEmpty(list);
}


List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}


int getRandomColor() {
  return Constants.randomColor[Random().nextInt(Constants.randomColor.length)];
}


bool stringEmpty(String str) {
  return str == null || str.length == 0;
}

bool stringNotEmpty(String str) {
  return !stringEmpty(str);
}

int getCurTimestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}
