import 'package:flutter/material.dart';
import 'package:flutter_local_book/reader/reader_scene.dart';

class AppNavigator {

  static push(BuildContext context, Widget scene) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => scene,
      ),
//        PageRouteBuilder(
//          transitionDuration: Duration(milliseconds: 300),
//          pageBuilder: (context, animation, secondaryAnimation) =>  scene,
//          transitionsBuilder: (context, animation, secondaryAnimation, child) {
////            Log.info('animation: ${animation.value}');
//            return SlideTransition(
//              position: Tween<Offset> (
//                begin: const Offset(1,0),
//                end: Offset.zero,
//              ).animate(CurvedAnimation(
//                  parent: animation,
//                  curve: Curves.fastOutSlowIn
//              )),
//              child: child,
//            );
//          },
//        )
    );
  }

  static pushReplacement(BuildContext context, Widget scene) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => scene,
      ),
    );
  }

  static pop(BuildContext context) {
    return Navigator.pop(context);
  }

  static pushReplacementReaderScene(BuildContext context, int bookId, int chapterOrder, int lastPage) {
    return AppNavigator.pushReplacement(context, ReaderScene(bookId, chapterOrder, lastPage));
  }
}