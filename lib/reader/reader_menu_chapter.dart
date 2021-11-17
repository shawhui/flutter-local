import 'package:flutter/material.dart';
import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';
import 'dart:async';
import 'package:flutter_local_book/common.dart';
import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';

class ReaderMenuChapter extends StatefulWidget {
  final void Function(int, int) onTypeTap;
  final int bookId;
  final int chapterOrder;

  ReaderMenuChapter(this.onTypeTap, this.bookId, this.chapterOrder);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReadMenuState();
  }
}

class ReadMenuState extends State<ReaderMenuChapter> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  bool isDesc = false;
  List<BookChapterModel> chapterList;
  int bookId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.bookId = this.widget.bookId;
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
    getList();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide(int type, int value) {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTypeTap(type, value);
    });
  }

  Future getList() async {
    List<BookChapterModel> model = await bookChapterModelProvider.getBookChapterByBookId(this.bookId, isDesc: this.isDesc);
    setState(() {
      chapterList = model;
    });
  }

  Widget buildItem(BookChapterModel data) {
    Color chapterColor = SCColor.primaryText;

    if (this.widget.chapterOrder == data.chapterOrder) {
      chapterColor = Color(0xFF3D7BFF);
    }

    return GestureDetector(
      onTap: () {
        hide(2, data.chapterOrder);
      },
      child: Container(
        color: Colors.white,
        height: 41,
        padding: EdgeInsets.all(0),
        child: Text(
          data.title,
          style: TextStyle(color: chapterColor, fontSize: FontPixel.p28, decoration: TextDecoration.none),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
//      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {},
          child: buildItem(chapterList[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
        );
      },
      itemCount: chapterList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Color(0x7F000000),
            width: Screen.width,
            height: Screen.height,
          ),
          Positioned(
            left: -300 * (1 - animation.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 300,
                  height: Screen.height,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: buildContent(),
                ),
                GestureDetector(
                  onTap: () {
                    hide(1, 0);
                  },
                  child: Container(
                    width: Screen.width - 300,
                    height: Screen.height,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (listEmpty(this.chapterList)) {
      return Container();
    }
    BookModel bookModel = Provider.of<BookShelfNotify>(context).getByBookId(this.bookId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 62,
        ),
        Text(
          bookModel.bookName,
          style: TextStyle(color: Colors.black, fontSize: FontPixel.p32, decoration: TextDecoration.none),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          children: <Widget>[
            Text(
              '完结  共${bookModel.totalChapter}章',
              style: TextStyle(color: Color(0xFFAEB1C0), fontSize: FontPixel.p22, decoration: TextDecoration.none),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                this.isDesc = !this.isDesc;
                getList();
              },
              child: Image.asset(isDesc ? 'img/chapter_up.png' : 'img/chapter_down.png'),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: listEmpty(chapterList) ? Container() : buildList(context),
        ),
      ],
    );
  }
}
