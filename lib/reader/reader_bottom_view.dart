import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:battery/battery.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_local_book/common.dart';

class ReaderBottomView extends StatefulWidget {

  final int page;

  ReaderBottomView(this.page);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BatteryViewState();
  }

}

class _BatteryViewState extends State<ReaderBottomView>{
  double batteryLevel = 0;
  Timer timer;
  String time;

  @override
  void initState() {
    super.initState();
    getBatteryLevel();
  }


  @override
  void dispose() {
    if(timer != null) {
      timer.cancel();
      timer = null;
    }

    super.dispose();
  }

  getBatteryLevel() async {
    timer = Timer.periodic(new Duration(seconds: 60), (time) async {
      if(timer == null) {
        return;
      }
      refresh();
    });
    refresh();
  }

  refresh() async {
    String time = DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch, format: DataFormats.h_m);
    setState(() {
      this.time = time;
    });
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        return;
      }
    }
    if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        return;
      }
    }
    if(mounted) {
      Battery _battery = Battery();
      var level = await _battery.batteryLevel;
      setState(() {
        this.batteryLevel = level / 100.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Color textColor = Color(SettingManager.instance.getTitleFontColor());
    return Container(
      child: Row(
        children: <Widget>[
          //电池
          buildBatteryView(textColor),
          SizedBox(width: 10),
          Text(time, style: TextStyle(fontSize: fixedFontSize(11), color: textColor, decoration: TextDecoration.none)),
          Expanded(child: Container()),
          Text('第${this.widget.page + 1}页', style: TextStyle(fontSize: fixedFontSize(11), color: textColor, decoration: TextDecoration.none)),
        ],
      ),
    );
  }

  buildBatteryView(Color color) {
    return Container(
      width: 27,
      height: 12,
      child: Stack(
        children: <Widget>[
          Image.asset('img/reader_battery.png'),
          Container(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
            width: 20 * batteryLevel,
            color: color,
          )
        ],
      ),
    );
  }
}
