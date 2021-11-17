import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_book/widget/root_bottom_bar.dart';
import 'book_shelf_scene.dart';
import 'search_book.dart';
class RootScene extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RootSceneState();
  }
}

class RootSceneState extends State<RootScene> {

  int _tabIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: IndexedStack(
        children: <Widget>[
          new BookShelfScene(),
          new SearchBookScene()
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: RootBottomBar(
        _tabIndex ,
            (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}