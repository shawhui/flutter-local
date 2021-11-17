import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';
import 'package:flutter_local_book/model/book_shelf_notify.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/db/book_mode_provider.dart';
import 'package:flutter_local_book/util/utils.dart';

class BookParse {

  String text;

  BookParse(this.text);

  Future<bool> parse(String bookName) async {
    List<String> lineList = text.split('\n');

    print('lineList:${lineList.length}');

    RegExp chapterMatch = RegExp(r"第.{1,8}章|^\d+");

    String title='';
    String chapterText='';
    int chapterOrder=0;

    BookModel bookModel = await bookModelProvider.getBookByName(bookName);
    if(bookModel == null) {
      bookModel = await bookModelProvider.insert(BookModel(bookName, 0,0, updateAt: getCurTimestamp()));
      if(bookModel == null) {
        print('parse create db bookname:$bookName  falie');
        return Future.value(false);
      }
    }

    await bookChapterModelProvider.deleteByBookId(bookModel.id);
    print('parse create db bookname:$bookName  success');

    for(String line in lineList) {

      print('line:$line');
      print('match: ${chapterMatch.hasMatch(line)}');

      if(chapterMatch.hasMatch(line)) {
        //title
//        print('title: $line');
        if(title.isNotEmpty) {
          await bookChapterModelProvider.insert(BookChapterModel(bookModel.id, title, chapterOrder++, chapterText, getCurTimestamp()));
//          print('parse insert chapter text:$chapterText');
        }
        title = line.replaceAll('　　', '');
        chapterText='';
      } else {
        //text
        if(line != '\r' && !line.contains('更新时间:')) {
          chapterText += line.replaceAll('\r', '\n');
        }
      }
    }
    print('chapterText:$chapterText');
    if(chapterText.isNotEmpty) {
      print('insert chapterText:$chapterText');
      await bookChapterModelProvider.insert(BookChapterModel(bookModel.id, title, chapterOrder++, chapterText, getCurTimestamp()));
    }

    bookModel.totalChapter = chapterOrder;

    await bookModelProvider.update(bookModel);

    print('parse finsh total chapterOrder: $chapterOrder');
    return Future.value(true);
  }


}