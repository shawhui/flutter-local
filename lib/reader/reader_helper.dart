import 'package:flutter_local_book/db/bookchapter_mode_provider.dart';

import 'book_util.dart';
import 'reader_config.dart';
import 'page_info.dart';
import 'package:flutter_local_book/manage/setting_manager.dart';
import 'package:flutter_local_book/common.dart';
import 'package:flutter_local_book/db/bookshelf_mode_provider.dart';

enum WitchOne { PRE, CUR, NEXT }

class ReaderHelperCache {
  BookUtil bookUtil;
  double width;
  double height;
  double fontSize;
  int bookId;
  int curChapter;

  int lastChapter;
  int shelf;
  int books;
  int shubi;

  int curX1=0;
  int curX2=0;

  void Function(int) callBack;

  Map<int, ChapterInfo> chapterMap;

  void register(int bookId, void Function(int) back) {
    bookUtil = BookUtil();
    chapterMap = Map<int, ChapterInfo>();
    realPageInfos = List<PageInfo>();
    this.callBack = back;
    this.bookId = bookId;
  }

  void init() {
    fontSize = SettingManager.instance.getFontSize();
    width = ReaderConfig.instance.readWidth;
    height = ReaderConfig.instance.readHeight;
    curPage=0;
    print('fontSize:$fontSize  ');
  }

  void reload() {
    chapterMap.clear();
    start(this.curChapter);
  }

  void start(int startChapter) async {
    init();
    this.curChapter = startChapter;
    print('start load curChapter:$startChapter');
    ChapterInfo chapterInfo = await loadChapter(startChapter, isCache: false);
    if (chapterInfo == null) {
      return;
    }
    chapterInfo.range = ChapterRange(curPage, chapterInfo.pageInfos.length);
    chapterMap[curChapter] = chapterInfo;

    callBack(1);

    print('curX1:$curX1  curX2:$curX2  ');
    if (curChapter - 1 >= 0) {
      int chapter = curChapter-1;
      print('start load  prechapter:$chapter');
      chapterInfo = await loadChapter(chapter);
      if (chapterInfo == null) {
        return;
      }
      chapterInfo.range = getChapterRange(chapter, false, chapterInfo.pageInfos.length);
      chapterMap[chapter] = chapterInfo;
    }


    if (curChapter + 1 <= lastChapter) {
      int chapter = curChapter+1;
      print('start load next chapter:$chapter');
      chapterInfo = await loadChapter(chapter);
      if (chapterInfo == null) {
        return;
      }
      chapterInfo.range = getChapterRange(chapter, true, chapterInfo.pageInfos.length);
      chapterMap[chapter] = chapterInfo;

    }
  }

  ChapterRange getChapterRange(int chapter, bool isNext, int length) {
    if(isNext) {
      if(chapterMap[chapter-1] == null) {
        print('this is error getChapterRange  chapter:$chapter,   isNext:$isNext');
        return null;
      }

      return ChapterRange(chapterMap[chapter-1].range.getLast(), length);
    } else {
      if(chapterMap[chapter+1] == null) {
        print('this is error getChapterRange  chapter:$chapter,   isNext:$isNext');
        return null;
      }

      return ChapterRange(chapterMap[chapter+1].range.start - length, length);
    }
  }

  Future<ChapterInfo> loadChapter(int chapter, {bool isCache=true}) async {
    print('loadChapter:$chapter');
    ChapterInfo chapterInfo;
    if(isCache) {
      chapterInfo = chapterMap[chapter];
      if (chapterInfo != null) {
        //有缓存，字号相同
        if (chapterInfo.key == getKey(chapter, fontSize)) {
//        callBack(1);
          return chapterInfo;
        }
      }
    }

    if (chapterInfo != null) {
      String content = chapterInfo.content;

      PageInfo info = chapterInfo.pageInfos[0];
      String chapterName = info.chapterName;

      List<PageInfo> pageInfo = await bookUtil.initPage(
          content, width, height, fontSize, chapter, chapterName);

      chapterInfo = ChapterInfo(
          chapter, content, pageInfo, getKey(chapter, fontSize));

      return chapterInfo;
    }

    BookChapterModel model = await bookChapterModelProvider.getBookIdChapterId(bookId, chapter);
    if (model == null) {
      Toast.show('没找到对应章节，请重试');
      return null;
    }

    String content = model.chapterText;
    String chapterName = model.title;
    lastChapter = bookShelfNotify.getByBookId(bookId).totalChapter-1;

    List<PageInfo> pageInfo = await bookUtil.initPage(
        content, width, height, fontSize, chapter, chapterName);

    chapterInfo = ChapterInfo(
        chapter, content, pageInfo, getKey(chapter, fontSize));

    return chapterInfo;
  }

  String getKey(int chapter, double fontSize) {
    return '$chapter-$fontSize';
  }

  void nextChapter() async {
    if (curChapter + 1 <= lastChapter) {

      curChapter = curChapter + 1;
      print('chapterMap length:${chapterMap.length}');
      int chapter = curChapter + 1;
      if(chapter > lastChapter) {
        return;
      }
      print('nextChapter 加载下一个章节章节  curChapter:$chapter');
      ChapterInfo chapterInfo = await loadChapter(chapter);
      if (chapterInfo == null) {
        return;
      }

      chapterInfo.range = getChapterRange(chapter, true, chapterInfo.pageInfos.length);
      chapterMap[chapter] = chapterInfo;

      clearMoreChapter();

      print('chapterMap length:${chapterMap.length}');
      print('realPageInfos length:${realPageInfos.length}');
    } else if (curChapter == lastChapter) {
      print('结束章节  curChapter+1:${curChapter + 1}');
    } else {
      print('无效章节  curChapter+1:${curChapter + 1}');
    }
  }

  void clearMoreChapter() {
    print('clearMoreChapter 111 chapterMap :${chapterMap.length}');
    int chapter = curChapter - 2;
    if(chapterMap[chapter] != null) {
      print('clearMoreChapter claer :$chapter');
      chapterMap.remove(chapter);
    }

    chapter = curChapter + 2;
    if(chapterMap[chapter] != null) {
      print('clearMoreChapter claer :$chapter');
      chapterMap.remove(chapter);
    }
    print('clearMoreChapter 222  chapterMap :${chapterMap.length}');
  }

  void preChapter() async {
    if (curChapter - 1 >= 0) {
      curChapter = curChapter - 1;

      int chapter = curChapter - 1;
      print('加载上一个章节章节  curChapter::$chapter');
      if(chapter < 0) {
        return;
      }
      ChapterInfo chapterInfo = await loadChapter(chapter);
      if (chapterInfo == null) {
        return;
      }

      chapterInfo.range = getChapterRange(chapter, false, chapterInfo.pageInfos.length);
      chapterMap[chapter] = chapterInfo;

      clearMoreChapter();

    } else if (curChapter == 0) {
      print('开始 章节 curChapter::${curChapter - 1}');
    } else {
      print('无效章节  curChapter::${curChapter - 1}');
    }
  }

  bool prePage() {
    if (curPage == 0) {
      if (curChapter == 0) {
        Toast.show('已经是第一章了');
        return false;
      }
    }
    return true;
  }

  bool nextPage() {
    if (curPage >= curChapterPageLength(curChapter) - 1) {
      if (curChapter > lastChapter) {
        Toast.show('已经是最后一章了');
        return false;
      }
    }
    return true;
  }

  void changePage(int page) {
    if(page != this.curPage) {
      //判断是否是当前章节内容
      ChapterInfo chapterInfo = chapterMap[curChapter];
      int curX1= chapterInfo.range.start;
      int curX2=chapterInfo.range.getLast();
//      print('curX1:$curX1    curX2:$curX2   curPage:${this.curPage}');
      //前翻
      if(page <= curX1) {
        preChapter();
      }
      //后翻
      if(page >= curX2) {
        nextChapter();
      }

      this.curPage = page;
    }


  }

  static int pageInit=1000;
  int curPage;
  List<PageInfo> realPageInfos;

  int getCurPage() => curPage;

  PageInfo getPageInfo(int index) {

    PageInfo pageInfo = getPageInfoByChapter(curChapter, index);
    if(pageInfo == null) {
      pageInfo = getPageInfoByChapter(curChapter+1, index);
    }
    if(pageInfo == null) {
      pageInfo = getPageInfoByChapter(curChapter-1, index);
    }

    return pageInfo;
  }

  PageInfo getPageInfoByChapter(int chapter, int page) {
    ChapterInfo chapterInfo = chapterMap[chapter];
    if(chapterInfo == null) {
      return null;
    }

    return chapterInfo.getPageInfoByPage(page);
  }

  int totalPage() {
    return chapterMap.length == 0 ? 0: 10000;
  }

  bool isShelf() => shelf == null || shelf == 1;

  int curChapterPageLength(int chapter) => chapterMap[chapter].pageInfos.length;

  getCurChapter() => curChapter;

}


class ReaderHelper {
  BookUtil bookUtil;
  double width;
  double height;
  double fontSize;
  int bookId;
  int curChapter;

  int lastChapter;
  int shelf;
  int books;
  int shubi;

  int curX1=0;
  int curX2=0;
  int initLastPage=0;

  void Function(int) callBack;

  ChapterInfo curChapterInfo;

  void register(int bookId, void Function(int) back) {
    bookUtil = BookUtil();
    realPageInfos = List<PageInfo>();
    this.callBack = back;
    this.bookId = bookId;
  }

  void init() {
    fontSize = SettingManager.instance.getFontSize();
    width = ReaderConfig.instance.readWidth;
    height = ReaderConfig.instance.readHeight;
    curPage=0;
    curChapterInfo=null;

    print('fontSize:$fontSize  ');
  }

  void reload() {
    start(this.curChapter);
  }

  void start(int startChapter, {int lastPage=0}) async {
    init();
    print('start curChapter:$startChapter');
    this.curChapter = startChapter;

    print('start load curChapter:$startChapter');
    ChapterInfo chapterInfo = await loadChapter(startChapter);
    if (chapterInfo == null) {
      return;
    }
    chapterInfo.range = ChapterRange(curPage, chapterInfo.pageInfos.length);

    print('startchapterInfo.pageInfos.length:${chapterInfo.pageInfos.length}');
    print('startchapterInfo range:${chapterInfo.range.start} -- ${chapterInfo.range.getLast()}');
    curChapterInfo = chapterInfo;
    curPage=pageInit+lastPage+1;
    print('curPage:$curPage    lastPage:$lastPage');
    callBack(1);

  }

  Future<ChapterInfo> loadChapter(int chapter) async {
    print('loadChapter:$chapter');
    ChapterInfo chapterInfo;
    if(curChapterInfo != null && curChapterInfo.chapter == chapter) {
      chapterInfo = curChapterInfo;
    }

    if (chapterInfo != null) {
      String content = chapterInfo.content;
      PageInfo info = chapterInfo.pageInfos[0];
      String chapterName = info.chapterName;

      List<PageInfo> pageInfo = await bookUtil.initPage(
          content, width, height, fontSize, chapter, chapterName);

      addPageFirstEnd(pageInfo);

      chapterInfo = ChapterInfo(
          chapter, content, pageInfo, getKey(chapter, fontSize));

      return chapterInfo;
    }

    BookChapterModel model = await bookChapterModelProvider.getBookIdChapterId(bookId, chapter);
    if (model == null) {
      Toast.show('没找到对应章节，请重试');
      return null;
    }
    eventBus.fire(BookDetailUpdate(false, bookId, chapter: chapter));

    String content = model.chapterText;
    String chapterName = model.title;
    lastChapter = bookShelfNotify.getByBookId(bookId).totalChapter-1;

    List<PageInfo> pageInfo = await bookUtil.initPage(
        content, width, height, fontSize, chapter, chapterName);
    addPageFirstEnd(pageInfo);
    chapterInfo = ChapterInfo(
        chapter, content, pageInfo, getKey(chapter, fontSize));

    return chapterInfo;
  }

  void addPageFirstEnd(List<PageInfo> pageInfo) {

    if(curChapter == 0) {
      //若是首章节，则不加前置loading页，加后置页，并第一页设置禁左
      pageInfo[0].actionType = PageActionType.FIRST;
    } else if(curChapter == lastChapter) {
      //若是最后章节，则加前置loading页，不加后置页，并最后一页设置禁左
      pageInfo[pageInfo.length-1].actionType = PageActionType.END;
    }
    PageInfo first = PageInfo(null, null);
    first.type = PageType.LOAD;
    first.actionType=PageActionType.FIRST;
    pageInfo.insert(0, first);
    PageInfo end = PageInfo(null, null);
    end.type = PageType.LOAD;
    end.actionType=PageActionType.END;
    pageInfo.add(end);

  }

  String getKey(int chapter, double fontSize) {
    return '$chapter-$fontSize';
  }

  void nextChapter() async {
    if (curChapter + 1 <= lastChapter) {

      curChapter = curChapter + 1;
      if(curChapter > lastChapter) {
        return;
      }
      print('nextChapter 加载下一个章节章节  curChapter:$curChapter');
      ChapterInfo chapterInfo = await loadChapter(curChapter);
      if (chapterInfo == null) {
        return;
      }

      chapterInfo.range = ChapterRange(pageInit, chapterInfo.pageInfos.length);
      curChapterInfo = chapterInfo;
      curPage = pageInit+1;
      callBack(1);
      print('realPageInfos length:${realPageInfos.length}');
    } else if (curChapter == lastChapter) {
      print('结束章节  curChapter+1:${curChapter + 1}');
    } else {
      print('无效章节  curChapter+1:${curChapter + 1}');
    }
  }

  void preChapter() async {
    if (curChapter - 1 >= 0) {
      curChapter = curChapter - 1;
      if(curChapter < 0) {
        return;
      }
      print('加载上一个章节章节  curChapter::$curChapter');
      ChapterInfo chapterInfo = await loadChapter(curChapter);
      if (chapterInfo == null) {
        return;
      }

      chapterInfo.range = ChapterRange(pageInit, chapterInfo.pageInfos.length);
      curChapterInfo = chapterInfo;
      curPage = chapterInfo.range.getLast()-1;
      callBack(1);
    } else if (curChapter == 0) {
      print('开始 章节 curChapter::${curChapter - 1}');
    } else {
      print('无效章节  curChapter::${curChapter - 1}');
    }
  }

  bool prePage({tip=true}) {
    if (curPage == 1) {
      if (curChapter == 0) {
        if(tip) {
          Toast.show('已经是第一章了');
        }
        return false;
      }
    }
    return true;
  }

  bool nextPage({tip=true}) {
    if (curChapter == lastChapter) {
      if (curPage >= curChapterPageLength(curChapter) - 1 - 1) {
        if(tip) {
          Toast.show('已经是最后一章了');
        }
        return false;
      }
    }
    return true;
  }

  void changePage(int page) {
    print('changePage:$page');
    if(page != this.curPage) {
      //判断是否是当前章节内容
      ChapterInfo chapterInfo = curChapterInfo;
      int curX1= chapterInfo.range.start;
      int curX2=chapterInfo.range.getLast();
//      print('curX1:$curX1   curX2:$curX2');
      //前翻
      if(page <= curX1) {
        preChapter();
      }
      //后翻
      if(page >= curX2) {
        nextChapter();
      }

      this.curPage = page;
    }
  }

  static int pageInit=0;
  int curPage=0;
  List<PageInfo> realPageInfos;

  int getCurPage() => curPage;

  PageInfo getPageInfo(int index) {
    PageInfo pageInfo = getPageInfoByChapter(curChapter, index);
    if(pageInfo == null) {
      pageInfo = PageInfo(null, null);
      pageInfo.type = PageType.LOAD;
    }
    return pageInfo;
  }

  PageInfo getPageInfoByChapter(int chapter, int page) {
    ChapterInfo chapterInfo = curChapterInfo;
    if(chapterInfo == null) {
      return null;
    }

    return chapterInfo.getPageInfoByPage(page);
  }

  int totalPage() {
    return 10000;
  }

  bool isShelf() => shelf == null || shelf == 1;

  int curChapterPageLength(int chapter) => curChapterInfo.pageInfos.length;

  getCurChapter() => curChapter;


}





