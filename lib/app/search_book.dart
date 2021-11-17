import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_book/common.dart';
class SearchBookScene extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('找书'),),
      body: Column(
        children: <Widget>[
          buildButton('去找书 站点1', 'https://www.jjxsw.la/e/action/ListInfo.php?page=1&classid=48&line=10&tempid=3&ph=1&andor=and&orderby=2&myorder=0'),
          buildButton('去找书 站点2', 'https://www.555x.org/'),
        ],
      ),
    );
  }

  Widget buildButton(String text, String url) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
      decoration: BoxDecoration( //Decoration背景设定（边框、圆角、阴影、形状、渐变、背景图像等）
        borderRadius: BorderRadius.circular(40),
        color: Colors.blue,
      ),
      height: 48,
      child: FlatButton(
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Text(text,
          style: TextStyle(fontSize: 16, color: Color(0xffffffff)),

        ),
      ),
    );
  }
}