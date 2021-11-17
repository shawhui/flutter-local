import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_book/common.dart';

class ReadFontSetting extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onRefresh;
  final VoidCallback onChangeSize;

  ReadFontSetting(this.onTap, this.onRefresh, this.onChangeSize);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReadFontSettingState();
  }
}

class ReadFontSettingState extends State<ReadFontSetting> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  int timeType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
    });
  }

  buildTimeView() {
    List<int> colors = SettingManager.instance.getBackgroundColors();
    return Positioned(
      bottom: -(Screen.height / 2) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Color(SettingManager.instance.getSettingBackground()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      '字体',
                      style: TextStyle(color: SCColor.primaryText, fontSize: FontPixel.p20, decoration: TextDecoration.none),
                    ),
                    Text(
                      '大小',
                      style: TextStyle(color: SCColor.primaryText, fontSize: FontPixel.p20, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (SettingManager.instance.setting.fontSize <= 16) {
                      Toast.show('已经是最小字体');
                    } else {
                      SettingManager.instance.setting.fontSize -= 2;
                      SettingManager.instance.update();
                      this.widget.onChangeSize();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFF1D3D4E),
                    ),
                    child: Text(
                      'A-',
                      style: TextStyle(color: Colors.white, fontSize: FontPixel.p26, decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    SettingManager.instance.getFontSize().toInt().toString(),
                    style: TextStyle(color: Color(0xFF222A20), fontSize: FontPixel.p30, decoration: TextDecoration.none),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    if (SettingManager.instance.setting.fontSize >= 26) {
                      Toast.show('已经是最大字体');
                    } else {
                      SettingManager.instance.setting.fontSize += 2;
                      SettingManager.instance.update();
                      this.widget.onChangeSize();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFF1D3D4E),
                    ),
                    child: Text(
                      'A+',
                      style: TextStyle(color: Colors.white, fontSize: FontPixel.p26, decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      '背景',
                      style: TextStyle(color: SCColor.primaryText, fontSize: FontPixel.p20, decoration: TextDecoration.none),
                    ),
                    Text(
                      '颜色',
                      style: TextStyle(color: SCColor.primaryText, fontSize: FontPixel.p20, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: map<Widget>([0xFFD2E2BD, 0xFFF3D6C4, 0xFFC6DDE2, 0xFFC7D0EA, 0xFFA5D6D6], (int index, int color) {
                    return GestureDetector(
                      onTap: () {
                        if (SettingManager.instance.setting.colorStyle == index) {
                          SettingManager.instance.setting.colorStyle = -1;
                        } else {
                          SettingManager.instance.setting.colorStyle = index;
                        }
                        SettingManager.instance.update();
                        this.widget.onRefresh();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(colors[index]),
                            border: Border.all(
                              color: index == SettingManager.instance.getStyle() ? Color(0xFF3D7BFF) : Color(colors[index]),
                            )),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
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
          buildTimeView(),
        ],
      ),
    );
  }
}
