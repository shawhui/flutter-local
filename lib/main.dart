import 'package:flutter/material.dart';
import 'app/app_scene.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart' show MultiProvider, ChangeNotifierProvider;
import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'common.dart';
void main() {
  //打开可视化调试
//  debugPaintSizeEnabled = true;
  //随时将堆栈跟踪日志打印到控制台
//  debugPrintMarkNeedsLayoutStacks =true;

  bookShelfNotify = BookShelfNotify();
  runApp(MultiProvider(
    providers:[
      ChangeNotifierProvider(builder: (_)=> bookShelfNotify),
    ],
    child: AppScene(),
  ));
  if (Platform.isAndroid) {
    //设置沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
