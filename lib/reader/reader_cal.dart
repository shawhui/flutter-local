import 'package:flutter/material.dart';
import 'page_info.dart';
import 'reader_config.dart';

class ReaderCal {

  int bookLen;
  int position;
  String content;
  int sectionIndex;
  bool isStart;
  bool isWeight;
  ReaderCal(this.content, {this.isWeight=false});

  init() {
    this.bookLen=content.length;
    this.position=-1;
    this.sectionIndex=0;
    isStart=true;
    return this;
  }

  String next(bool back){
    position += 1;
    if (position > bookLen){
      position = bookLen;
      return null;
    }
    String result = current();
    if (back) {
      position -= 1;
    }
    return result;
  }

  String current(){
    if(position < bookLen) {
      return content[position];
    }

    return null;
  }

  void back() {
    position -=1;
  }

  PageInfo getOnePage(TextPainter textPainter, double width, double height,
      double fontSize, double defaultWidth, double defaultHeight, {PageInfo pageInfo}) {
    List<PageLineInfo> lines;
    List<PageSectionInfo> sectionInfoList;
    if (pageInfo != null) {
      lines = pageInfo.texts;
      sectionInfoList = pageInfo.sectionInfo;
      sectionIndex = pageInfo.sectionInfo.length;
    }
    if (lines == null) {
      lines = List<PageLineInfo>();
    }
    if (sectionInfoList == null) {
      sectionInfoList = List<PageSectionInfo>();
    }


    double leftDefault=defaultWidth*2;
    double positionW=0;
    if(isStart) {
      positionW = leftDefault;
    }
    double positionH = 0;
    String line = "";
    String sectionText = "";

    while (next(true) != null) {
//      if(sectionIndex < 15) {
//        print('positionH:$positionH  positionH + defaultHeight:${positionH + defaultHeight}   height:$height ');
//      }
      if (positionH + defaultHeight > height) {
        break;
      }

      String word = next(false);
//      if(sectionIndex < 6) {
//        print('word:$word');
//      }
      double widthChar;
//      double heightChar;
      int code = word.codeUnitAt(0);
      if (19968 <= code && code <= 40869) {
        widthChar = defaultWidth;
//        heightChar = defaultHeight;
//        print('this.is right word:$word      code:$code');
      } else {
        textPainter.text =
            TextSpan(text: word, style: TextStyle(fontSize: fontSize,),);
        textPainter.layout();
        widthChar = textPainter.width;
//        heightChar = textPainter.height;

//        print('this.is error  word:$word    code:$code    widthChar:$widthChar   heightChar:$heightChar ');
      }

      //判断是否换行
      if (word == '\n') {
        if (line.isNotEmpty) {
          //换行，切有内容
          double left=0;
          if(isStart) {
            left=leftDefault;
          }

          if(positionH + defaultHeight+ReaderConfig.instance.sectionSpace > height) {
            lines.add(PageLineInfo(line, sectionIndex, fontSize, defaultHeight, left: left, bottom: 0, isWeight: this.isWeight));
            positionH += defaultHeight;
          } else {
            lines.add(PageLineInfo(
                line, sectionIndex, fontSize, defaultHeight, left: left,
                bottom: ReaderConfig.instance.sectionSpace, isWeight: this.isWeight));
            positionH += defaultHeight + ReaderConfig.instance.sectionSpace;

          }

          sectionInfoList.add(PageSectionInfo(sectionIndex, sectionText));
          line = "";
          sectionText = '';
          positionW = leftDefault;

//          print('positionH:$positionH');
          sectionIndex++;
        }
        isStart =true;
      } else {
//        print('=======  if ${word != ' '}');
        if (line.isNotEmpty ||  (word != ' ' && word != '　')) {
          positionW += widthChar;
//        if(sectionIndex < 6) {
//          print('positionW:$positionW  widthChar:$widthChar word:$word');
//        }
          if (positionW >= width) { //换行
            double left = 0;
            if (isStart) {
              left = leftDefault;
            }
            lines.add(PageLineInfo(
                line, sectionIndex, fontSize, defaultHeight, left: left,
                bottom: 0, isWeight: this.isWeight));
//          sectionText = sectionText + line;
            positionW = widthChar;
            positionH += defaultHeight;

            if (positionH + defaultHeight > height) {
              //此处换行，距离不够所以回退 line已消费应清空
              line='';
              back();
            } else {
              line = word;
              sectionText += word;
            }
//            print('positionH:$positionH');
            isStart = false;
          } else {
            line += word;
            sectionText += word;
          }
        }
      }
    }

    if (sectionText.isNotEmpty) {
      sectionInfoList.add(PageSectionInfo(sectionIndex, sectionText));
    }

    if(line.isNotEmpty) {
      lines.add(PageLineInfo(
          line, sectionIndex, fontSize, defaultHeight, left: 0,
          bottom: ReaderConfig.instance.sectionSpace, isWeight: this.isWeight));

    }

//    if(sectionIndex < 30) {
//      sectionInfoList.forEach((PageSectionInfo info) {
//        print('index:${info.index}  content:${info.content}');
//      });
//
//      lines.forEach((str) {
//        print(str.content);
//      });
//    }
    if(lines.length == 0) {
      return null;
    }

    return PageInfo(sectionInfoList, lines);
  }


  PageInfo getOneChapter(TextPainter textPainter, double width, double height,
      double fontSize, double defaultWidth, double defaultHeight) {
    List<PageLineInfo> lines= List<PageLineInfo>();
    List<PageSectionInfo> sectionInfoList= List<PageSectionInfo>();

    double positionW=0;
    double positionH = 0;
    String line = "";
    String sectionText = "";

    while (next(true) != null) {
      if (positionH + defaultHeight > height) {
        break;
      }

      String word = next(false);
      double widthChar;
//      double heightChar;
      int code = word.codeUnitAt(0);
      if (19968 <= code && code <= 40869) {
        widthChar = defaultWidth;
      } else {
        textPainter.text =
            TextSpan(text: word, style: TextStyle(fontSize: fontSize,),);
        textPainter.layout();
        widthChar = textPainter.width;
      }

      //判断是否换行
      if (word == '\n') {
        if (line.isNotEmpty) {
          if(positionH + defaultHeight+ReaderConfig.instance.sectionSpace > height) {
            lines.add(PageLineInfo(line, sectionIndex, fontSize, defaultHeight, left: 0, bottom: 0, isWeight: this.isWeight));
            positionH += defaultHeight;
          } else {
            lines.add(PageLineInfo(
                line, sectionIndex, fontSize, defaultHeight, left: 0,
                bottom: ReaderConfig.instance.sectionSpace, isWeight: this.isWeight));
            positionH += defaultHeight + ReaderConfig.instance.sectionSpace;

          }

          sectionInfoList.add(PageSectionInfo(sectionIndex, sectionText));
          line = "";
          sectionText = '';
          positionW = 0;
          sectionIndex++;
        }
        isStart =true;
      } else {
        if (line.isNotEmpty ||  (word != ' ' && word != '　')) {
          positionW += widthChar;
          if (positionW >= width) { //换行
            double left = 0;
            lines.add(PageLineInfo(
                line, sectionIndex, fontSize, defaultHeight, left: left,
                bottom: 0, isWeight: this.isWeight));
            positionW = widthChar;
            positionH += defaultHeight;

            if (positionH + defaultHeight > height) {
              //此处换行，距离不够所以回退 line已消费应清空
              line='';
              back();
            } else {
              line = word;
              sectionText += word;
            }
          } else {
            line += word;
            sectionText += word;
          }
        }
      }
    }

    if (sectionText.isNotEmpty) {
      sectionInfoList.add(PageSectionInfo(sectionIndex, sectionText));
    }

    if(line.isNotEmpty) {
      lines.add(PageLineInfo(
          line, sectionIndex, fontSize, defaultHeight, left: 0,
          bottom: ReaderConfig.instance.sectionSpace, isWeight: this.isWeight));
    }
    if(lines.isEmpty) {
      return null;
    }

    if(sectionIndex < 6) {
      sectionInfoList.forEach((PageSectionInfo info) {
        print('index:${info.index}  content:${info.content}');
      });

      lines.forEach((str) {
        print(str.content);
      });
    }
    return PageInfo(sectionInfoList, lines);
  }
}
