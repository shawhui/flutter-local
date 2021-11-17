import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_book/common.dart';
import 'package:screen/screen.dart' as screenBri;
class ReaderMenu extends StatefulWidget {
  final void Function(int) onTypeTap;

  ReaderMenu(this.onTypeTap);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReadMenuState();
  }

}

class ReadMenuState extends State<ReaderMenu> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> animation;
  double progressValue=0.0;
  bool isBrightnessVisible=false;

  SettingManager settingManager =SettingManager.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    progressValue = 0;//this.widget.articleIndex / (this.widget.chapters.length - 1);
    animationController = AnimationController(duration: const Duration(milliseconds: 200),vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();

    initData();
  }

  void initData() async {
    progressValue = await screenBri.Screen.brightness;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTypeTap(6);
    });

  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Screen.navigationBarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(color: SCColor.paper, boxShadow: Styles.borderShadow),
        height: Screen.navigationBarHeight,
        padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  this.widget.onTypeTap(7);
                },
                child: Image.asset('img/back.png'),
              ),
            ),
            Expanded(child: Container()),
//            GestureDetector(
//              onTap: () {
//                this.widget.onTypeTap(4);
//              },
//              child: Container(
//                width: 44,
//                child: Image.asset('img/read_menu_voice.png'),
//              ),
//            ),
//            GestureDetector(
//              onTap: () {
//                this.widget.onTypeTap(5);
//              },
//              child: Container(
//                width: 44,
//                child: Image.asset('img/read_menu_share.png'),
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  buildBrightnessProgress() {
    if(!isBrightnessVisible) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              progressValue-= 0.2;
              if(progressValue < 0) {
                progressValue=0;
                Toast.show('已调到最小亮度了');
              }
              setState(() {
              });
              screenBri.Screen.setBrightness(progressValue);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('img/read_menu_brightness_small.png'),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: SCColor.primaryText

              ),
              child: Slider(
                value: progressValue,
                onChanged: (double value) {
                  setState(() {
                    progressValue = value;
                  });
                  screenBri.Screen.setBrightness(value);
                },
                onChangeEnd: (double value) {
  //                Chapter chapter = this.widget.chapters[currentArticleIndex()];
  //                this.widget.onToggleChapter(chapter);
                },
//                activeColor: Colors.blue,
//                inactiveColor: Colors.yellow,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              progressValue +=0.2;
              if(progressValue > 1) {
                progressValue=1;
                Toast.show('已调到最大亮度了！');
              }
              setState(() {
              });
              screenBri.Screen.setBrightness(progressValue);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('img/read_menu_brightness.png'),
            ),
          )
        ],
      ),
    );
  }

  buildBottomMenus() {
    return Row(
      children: <Widget>[
        buildBottomItem('目录', 'img/read_menu_catalog.png', 1),
//        buildBottomItem('亮度', 'img/read_menu_brightness.png', 7),
        settingManager.setting.nightMode ? buildBottomItem('白天', 'img/read_menu_sun.png', 2)
        :buildBottomItem('夜间', 'img/read_menu_night.png', 2),
        buildBottomItem('设置', 'img/read_menu_font.png', 3),
      ],
    );
  }

  buildBottomItem(String title, String icon, int type) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if(type==7) {
            setState(() {
              this.isBrightnessVisible=!isBrightnessVisible;
            });
          } else {
            this.widget.onTypeTap(type);
          }
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5),
              Image.asset(icon),
              Text(title, style: TextStyle(fontSize: fixedFontSize(12), color: SCColor.darkGray, decoration: TextDecoration.none)),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  buildBottomView() {
    return Positioned(
      bottom: -(Screen.bottomSafeHeight + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: SCColor.paper, boxShadow: Styles.borderShadow),
            padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
            child: Column(
              children: <Widget>[
//                buildProgressView(),
//                buildBrightnessProgress(),
                buildBottomMenus(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide();
            },
            child: Container(color: Colors.transparent),
          ),
          buildTopView(context),
          buildBottomView(),
        ],
      ),
    );
  }

}