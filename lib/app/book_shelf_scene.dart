import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_book/app_navigator.dart';
import 'package:flutter_local_book/db/bookshelf_mode_provider.dart';
import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'package:flutter_local_book/reader/reader_scene.dart';
import 'package:flutter_local_book/util/utils.dart';
import 'dart:io';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:flutter_local_book/public.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';
import 'package:flutter_local_book/util/book_parse.dart';
import 'book_chapter_list_scene.dart';

class BookShelfScene extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new BookShelfSceneState();
  }
}


class BookShelfSceneState extends State<BookShelfScene> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  Widget buildBody(context, List<BookModel> list) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
      child: ListView.separated(
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              BookModel bookModel = list[index];
              if(bookModel.lastChapter == 0) {
                AppNavigator.push(context, BookChapterListScene(bookModel.id));
              } else {
                AppNavigator.push(context, ReaderScene(bookModel.id, bookModel.lastChapter, bookModel.lastPage));
              }

            },
            onLongPress: () async {
              int bookId = list[index].id;
              await bookModelProvider.delete(bookId);
              bookChapterModelProvider.deleteByBookId(bookId);
              bookShelfNotify.syncBook();
              Toast.show('已删除');
            },
            child: Container(
              height: 50,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text("${list[index].bookName}", style: TextStyle(fontSize: FontPixel.p36,
                      color: SCColor.primaryText)),
                  Expanded(child: Container(),),
                  Text("共${list[index].totalChapter}章", style: TextStyle(fontSize: FontPixel.p36,
                      color: SCColor.primaryText)),
                ],
              )
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 1,);
        },
        itemCount:list.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("书架"),
      ),
      body: Consumer<BookShelfNotify>(
        builder: (context, value, child) {
          if(value.isEmpty()) {
            return Center(
              child: Text('点击选择新书', style: TextStyle(fontSize: FontPixel.p28, color:SCColor.primaryText),),
            );
          }
          return buildBody(context, value.getList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          String fileName;
          try {

            File file = await FilePicker.getFile(type: FileType.any);
            var list = await file.readAsBytes();
            String text;
            try {
              text = gbk.decode(list);
            } catch (e) {
              text = await file.readAsString();
              print('text:$text');
            }
            fileName = file.path.split('/').last.replaceAll('.txt', '');
            fileName = fileName.replaceAll('[www.555x.org]', '');

            Toast.show('小说<$fileName>同步中...');
            await BookParse(text).parse(fileName);
          } on PlatformException catch (e) {
            print("Unsupported operation" + e.toString());
          }
          Toast.show('小说<$fileName>同步完成');
          bookShelfNotify.syncBook();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}