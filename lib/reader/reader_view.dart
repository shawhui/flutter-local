import 'package:flutter/material.dart';
import 'reader_bottom_view.dart';
import 'page_info.dart';
import 'reader_helper.dart';
import 'package:flutter_local_book/common.dart';
import 'reader_config.dart';
class ReaderView extends StatelessWidget {

  final PageInfo pageInfo;
  final int page;
  final ReaderHelper helper;

  ReaderView(this.pageInfo, this.page, this.helper);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Color(SettingManager.instance.getFontBackGround()),
        boxShadow: [
          BoxShadow(
              color: Color(0x7FADADAD),
              offset: Offset(5.0, 1.0), //阴影xy轴偏移量
              blurRadius: 5.0, //阴影模糊程度
              spreadRadius: 1.0 //阴影扩散程度
          )
        ],
      ),
      child: buildCenter(context),
    );
  }

  Widget buildCenter(BuildContext context) {
    if(this.pageInfo == null) {
      return buildEmpty();
    }

    if(this.pageInfo.type == PageType.LOAD) {
      return buildLoading();
    }
    return buildTextContent();
  }


  Widget buildTextContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ReaderConfig.instance.paddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: ReaderConfig.instance.topHeight,
            child: Text(pageInfo.chapterName,
              style: TextStyle(fontSize: fixedFontSize(14), color: Color(SettingManager.instance.getTitleFontColor()), decoration: TextDecoration.none),),
          ),

          Container(
            height: ReaderConfig.instance.readHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:map(pageInfo.texts, (int index, PageLineInfo lineInfo) {
                return Container(
                  margin: EdgeInsets.fromLTRB(lineInfo.left, 0 ,0 , lineInfo.bottom),
                  padding: EdgeInsets.all(0),
                  height: lineInfo.height,
                  child: Text(lineInfo.content, style: TextStyle(
                    fontSize: lineInfo.fontSize,
                    color: Color(SettingManager.instance.getFontColor()),
                    fontWeight: lineInfo.isWeight?FontWeight.w600:FontWeight.normal,
                      decoration: TextDecoration.none
                  ),
                  ),

                );
              }),
            ),
          ),
//        Container(
//          height: ReaderConfig.instance.readHeight,
//          child: Center(
//            child: Text('pageInfo:${pageInfo.chapterName}  page:$page'),
//          ),
//        ),
          Container(
            height: ReaderConfig.instance.bottomHeight,
            child: ReaderBottomView(pageInfo.page),
          ),
        ],
      ),
    );
  }
  buildEmpty() {
    return Center(
      child: Text('前方没有路，后方没有桥，不要翻了。'),
    );
  }

  buildLoading() {
    return Center(
      child: Container(
        width: 95.0,
        height: 95.0,
        decoration: ShapeDecoration(
          color: Color(0xAF4A4A4A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white,), strokeWidth: 3,),
            ),
          ],
        )
      ),
    );
  }
}