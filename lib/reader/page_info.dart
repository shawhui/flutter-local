import 'package:flutter/material.dart';

class PageSectionInfo {

  int index;
  String content;

  PageSectionInfo(this.index,this.content);

}



class PageLineInfo {

  String content;
  int sectionIndex;
  double left;
  double bottom;
  double fontSize;
  double height;
  bool isWeight;
  PageLineInfo(this.content, this.sectionIndex, this.fontSize, this.height, {this.left=0, this.bottom=0, this.isWeight=false});

}

enum PageType {
  COMMON,
  VIP,
  LOAD,
}

enum PageActionType {
  COMMON,
  FIRST,
  END,
}

class PageInfo {

  List<PageSectionInfo> sectionInfo;

  List<PageLineInfo> texts;

  int chapter;

  PageType type = PageType.COMMON;

  PageActionType actionType = PageActionType.COMMON;

  String chapterName;

  int page;

  PageInfo(this.sectionInfo, this.texts);

}


class ChapterInfo {
  List<PageInfo> pageInfos;
  String content;
  int chapter;
  String key;
  ChapterRange range;
  String chapterName;

  ChapterInfo(this.chapter, this.content, this.pageInfos, this.key);

  PageInfo getPageInfoByPage(int page) {
    if(range.isIn(page)) {
       return pageInfos[range.getIdx(page)];
    }
    return null;
  }
}


class ChapterRange{

  int start;
  int length;

  ChapterRange(this.start, this.length);

  bool isIn(int idx) {
    return start <= idx && idx < start+length;
  }

  int getIdx(int idx) {
    return idx - start;
  }

  int getLast() {
    return start+length-1;
  }
}