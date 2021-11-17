import 'package:flutter/material.dart';
import 'package:flutter_local_book/public.dart';
import 'package:flutter_local_book/util/screen.dart';
import 'page_info.dart';
import 'reader_config.dart';
import 'reader_cal.dart';
class BookUtil {

  BookUtil();

  Future<List<PageInfo>> initPage(String content, double width, double height, double fontSize,
      int chapter,String chapterName) async {

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr, textScaleFactor: 1.0);
    textPainter.text = TextSpan(text: '好', style: TextStyle(fontSize: fontSize));
    textPainter.layout();

    double defaultHeight= textPainter.height;
    double defaultWidth= textPainter.width;

    List<PageInfo> pageList = List<PageInfo>();


    int page=0;
    ReaderCal contentCal = ReaderCal(content).init();
    return Future.doWhile(() async {
      double pageHeight = height;
      PageInfo pageInfoChapter;
      if(page == 0) {
        double chapterHeight=0;
        pageInfoChapter = getChapterTitle(textPainter, chapterName, fontSize+4, width, height);
        chapterHeight = getPageInfoHeight(pageInfoChapter);
        pageHeight = pageHeight - chapterHeight;
      }

      PageInfo pageInfo = contentCal.getOnePage(textPainter, width, pageHeight,
          fontSize, defaultWidth, defaultHeight, pageInfo:pageInfoChapter);
      if (pageInfo != null) {
        pageInfo.type = PageType.COMMON;
        pageInfo.chapter = chapter;
        pageInfo.chapterName = chapterName;
        pageInfo.page=page++;
        pageList.add(pageInfo);
      }

      return Future.delayed(
          Duration(milliseconds: 1), () => Future.value(pageInfo != null));
    }).then((v) {
      return Future.value(pageList);
    });

  }

  PageInfo getChapterTitle(TextPainter textPainter, String chapterName, double fontSize, double width, double height) {
    ReaderCal titleCal = ReaderCal(chapterName, isWeight: true).init();
    textPainter.text = TextSpan(text: '好', style: TextStyle(fontSize: fontSize));
    textPainter.layout();

    return titleCal.getOneChapter(textPainter, width, height, fontSize, textPainter.width, textPainter.height);

  }

  double getPageInfoHeight(PageInfo pageInfo) {
    double height=0;
    if(pageInfo != null) {
      for(int i=0; i<pageInfo.texts.length; i++) {
        PageLineInfo lineInfo = pageInfo.texts[i];
        if(i == pageInfo.texts.length-1) {
          lineInfo.bottom = ReaderConfig.instance.chapterSpace;
        }
        height += lineInfo.height + lineInfo.bottom;
      }
    }
    return height;
  }


  Future<List<PageLineInfo>> getOnePageInfo(String content, double width, double height, double fontSize) {
    return Future(() {

      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr, textScaleFactor: 1.0);
      textPainter.text = TextSpan(text: '好', style: TextStyle(fontSize: fontSize));
      textPainter.layout();

      double defaultHeight= textPainter.height;
      double defaultWidth= textPainter.width;
      ReaderCal contentCal = ReaderCal(content).init();
      PageInfo pageInfo = contentCal.getOnePage(
          textPainter, width, height, fontSize, defaultWidth, defaultHeight);
      if(pageInfo == null) {
        return null;
      }
      return pageInfo.texts.map<PageLineInfo>((PageLineInfo lineInfo) {
        return lineInfo;
      }).toList();
    });
  }

}


double rotioW = Screen.width / 375 ;

double scale(double dp) {
  return dp * rotioW;
}