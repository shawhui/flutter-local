import 'package:flutter/material.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/app/splash_sceen.dart';

class AppScene extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "本地小说",
      debugShowCheckedModeBanner: false,      //去除右上角Debug标签
      theme: ThemeData(
        primaryColor: Colors.white,
//        dividerColor: Color(0xffeeeeee),
        scaffoldBackgroundColor: SCColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: SCColor.darkGray,decoration: TextDecoration.none), ),
      ),
      home: new SplashScene(),
      builder: (ctx, w) {
        return MaxScaleTextWidget(
          child: w,
        );
      },
    );
  }
}



class MaxScaleTextWidget extends StatelessWidget {
  final Widget child;

  const MaxScaleTextWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: 1.0),
      child: child,
    );
  }
}

