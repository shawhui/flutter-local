import 'dart:async';
import 'package:flutter/material.dart';
import 'page_drag.dart';
import 'package:flutter_local_book/common.dart';
import 'effect_page_controller.dart';
import 'effect_cal.dart';
class EffectView extends StatefulWidget {

  final IndexedWidgetBuilder itemBuilder;
  final EffectPageController pageController;

  EffectView(this.pageController, {this.itemBuilder});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EffectViewState();
  }
}

class EffectViewState extends State<EffectView>  with SingleTickerProviderStateMixin {

  StreamController<SlideUpdate> updateStream;

  Map<int, Widget> cacheMap = {};

  EffectCal effectCal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.widget.pageController.listen((EffectPageBloc data) {
      print('ActionType.JumpPage:  data:${data.value}');
      switch(data.type) {
        case ActionType.JumpPage:  //跳页
          print('ActionType.JumpPage:  data:${data.value}');
          if(data.value == 1) {
            effectCal.tapNextPage();
          } else {
            effectCal.tapPrePage();
          }

          break;
        case ActionType.ChangeChapter:
          break;
        default:
          break;
      }
    });


    updateStream = StreamController<SlideUpdate>();
    updateStream.stream.listen((SlideUpdate event) {
//      print('SlideUpdate  updateType:${event.updateType}  direction:${event.direction}  slidePercent:${event.slidePercent}');

      if (event.updateType == UpdateType.doneDragging) {

        switch(event.direction) {
          case Direction.leftToRightDeny:
            Toast.show('当前已是第一页了');
            break;
          case Direction.rightToLeftDeny:
            Toast.show('当前已是最后一页了');
            break;
          default:
            break;
        }
      } else if(event.updateType == UpdateType.doneAnimating){
        switch(event.direction) {
          case Direction.leftToRight:
            this.widget.pageController.previousPageNotify();
            break;
          case Direction.rightToLeft:
            this.widget.pageController.nextPageNotify();
            break;
          default:
            break;
        }
      }

      setState(() {
      });
    });

    effectCal = EffectCal()
      ..init(updateStream, this);
  }


  Widget getPageByIndex(int page, bool isCache) {
    Widget widget;
    if(isCache) {
      widget = cacheMap[page];
      if(widget == null) {
        widget = this.widget.itemBuilder(context, page);
        cacheMap[page] = widget;
      }
    } else {
      if(cacheMap.isNotEmpty) {
        cacheMap.clear();
      }
      widget = this.widget.itemBuilder(context, page);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int curPage = this.widget.pageController.getCurPage();

    int topPage = curPage+1;
    int bottomPage = curPage;

    if(effectCal.direction == Direction.rightToLeft) {
      topPage=curPage;
      bottomPage=topPage+1;
    } else if(effectCal.direction == Direction.leftToRight){
      bottomPage = curPage;
      topPage = bottomPage-1;
    }
//    print('build  topPage:$topPage  bottomPage:$bottomPage  isShowTop:${effectCal.isShowTop()}   direction:${effectCal.direction} ');
    bool isShowTop = effectCal.isShowTop();
    Widget top = getPageByIndex(topPage, !isShowTop);
    Widget bottom = getPageByIndex(bottomPage,!isShowTop);
    return Stack(
      children: <Widget>[
        bottom,
        Offstage(
          offstage: isShowTop,
          child: Transform.translate(
            offset: Offset(effectCal.getTransFormOffsetX(), 0),
            child: top,),
          ),
        PageDrag(
          canDragLeftToRight: isShowTop && this.widget.pageController.isCanLeftToRight(bottomPage),
          canDragRightToLeft: isShowTop && this.widget.pageController.isCanRightToLeft(bottomPage),
          slideUpdateStream: updateStream,
          effectCal:effectCal,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    updateStream?.close();
    effectCal?.dispose();
    super.dispose();
  }

}