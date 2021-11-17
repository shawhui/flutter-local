import 'package:flutter/material.dart';
import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/app_navigator.dart';
import 'package:flutter_local_book/util/utils.dart';

class BookChapterListScene extends StatefulWidget {

  final int bookId;
  final bool isBack;

  BookChapterListScene(this.bookId, {this.isBack=false});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookChapterListSceneState();
  }
}


class BookChapterListSceneState extends State<BookChapterListScene> {

  bool isDesc=false;
  List<BookChapterModel> chapterList;
  int bookId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookId=this.widget.bookId;
    getList();
  }


  Widget buildItem(BookChapterModel data) {
    return GestureDetector(
      onTap: () {
        if(this.widget.isBack) {
          Navigator.pop(context,data.chapterOrder);
        } else {
          AppNavigator.pushReplacementReaderScene(
              context, data.bookId, data.chapterOrder, 0);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Colors.transparent,
        child: Text(data.title, overflow: TextOverflow.ellipsis, maxLines: 1,),
      ),
    );
  }


  Future<void> getList() async {
    List<BookChapterModel> list = await bookChapterModelProvider.getBookChapterByBookId(this.bookId, isDesc: this.isDesc);
    setState(() {
      chapterList=list;
    });
  }

  
  Widget buildList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
//      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){

          },
          child: buildItem(chapterList[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1,);
      },
      itemCount:chapterList.length,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('章节'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: ()=> AppNavigator.pop(context),
          child: Image.asset('img/back.png'),
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(isDesc?Icons.expand_less:Icons.expand_more),
            tooltip: isDesc?"倒序":"正序",
            onPressed: (){
              this.isDesc = !isDesc;
              getList();
            },
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: listEmpty(chapterList) ? Container() : buildList(context),
      ),
    );
  }
}