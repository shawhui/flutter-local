import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/manage/setting_manager.dart';
import 'package:flutter_local_book/app_navigator.dart';
import 'root_scene.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';
import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'package:provider/provider.dart';

class SplashScene extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashSceneState();
  }
}

class SplashSceneState extends State<SplashScene> {

  BuildContext mContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  initApp() async {

    preferences = await SharedPreferences.getInstance();

    bookModelProvider = BookModelProvider();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book.db');
    await bookModelProvider.open(path);

    bookChapterModelProvider = BookChapterModelProvider();
    path = join(databasesPath, 'book_chapter.db');
    await bookChapterModelProvider.open(path);

    SettingManager.instance.init();
    Provider.of<BookShelfNotify>(mContext).syncBook();

    AppNavigator.pushReplacement(mContext, RootScene());

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mContext = context;
    return Container(
      color: SCColor.white,
      child: Center(
        child: Text('初始化中...', style: TextStyle(fontSize: FontPixel.p56, color:SCColor.primaryText, decoration: TextDecoration.none)),
      ),
    );
  }
}