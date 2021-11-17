import 'package:flutter/material.dart';
import 'package:flutter_local_book/public.dart';
class RootBottomBar extends StatefulWidget {

  final curIndex;
  final ValueChanged<int> onTap;

  RootBottomBar(this.curIndex, this.onTap);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RootBottomBarState();
  }
}


class RootBottomBarState extends State<RootBottomBar> {

  List<Image> _tabImages = [
    Image.asset('img/tab_bookshelf_n.png'),
    Image.asset('img/tab_bookstore_n.png'),
  ];
  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_bookshelf_p.png'),
    Image.asset('img/tab_bookstore_p.png'),
  ];

  Image getTabIcon(int index) {
    if (index == this.widget.curIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }

  Widget getTitle(int index) {
    List<String> titles = ['书架', '搜书'];
    int color = 0xFFAEB1C0;
    if (index == this.widget.curIndex) {
      color = 0xFF3D7BFF;
    }
    return Text(titles[index], style: TextStyle(color: Color(color), fontSize: FontPixel.p20),);
  }


  Widget buildItem(int idx) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          this.widget.onTap(idx);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getTabIcon(idx),
              SizedBox(height: 3.5,),
              getTitle(idx)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x3FADADAD),
              offset: Offset(-1.0, -3.0), //阴影xy轴偏移量
              blurRadius: 5.0, //阴影模糊程度
              spreadRadius: 1.0 //阴影扩散程度
          )
        ],
        color: Colors.white,
      ),
      child: Row(
        children:  List<int>.generate(2, (int index) => index).map((idx){
          return buildItem(idx);
        }).toList(),

      ),
    );
  }

}


