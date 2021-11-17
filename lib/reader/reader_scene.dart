import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page_info.dart';
import 'reader_font_setting.dart';
import 'reader_helper.dart';
import 'reader_view.dart';
import 'reader_menu.dart';
import 'reader_menu_chapter.dart';
import 'widget/effect_page_controller.dart';
import 'widget_s/page_gesture.dart';
import 'package:flutter_local_book/common.dart';
import 'widget/effect_view.dart';
class ReaderScene extends StatefulWidget {
  final int bookId;
  final int chapterOrder;
  final int lastPage;

  ReaderScene(this.bookId, this.chapterOrder, this.lastPage);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReaderSceneState();
  }
}

enum PageJumpType { stay, firstPage, lastPage }


class ReaderSceneState extends State<ReaderScene>  {
//  PageController pageController = PageController(keepPage: false, initialPage: ReaderHelper.pageInit);
  EffectPageController pageController;

  bool isMenuVisible = false;
  bool isVoiceVisible = false;
  bool isFontSettingVisible = false;
  bool isMenuChapterVisible = false;
  bool isShareVisible=false;

  ReaderHelper readerHelper=ReaderHelper();

  int bookId;
  int curChapter;
  var _eventReaderUpdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookId = this.widget.bookId;
    curChapter = this.widget.chapterOrder;

    readerHelper.register(this.bookId, (int type){
      if(type == 1) {
        setState(() {});
      }
    });
    pageController = EffectPageController(onPageChanged, readerHelper);

    _eventReaderUpdate = eventBus.on<ReaderUpdate>().listen((event) {
      if(event.update) {
        readerHelper.init();
      } else {
        if(mounted) {
          setState(() {});
        }
      }
    });
    setUp();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    if(_eventReaderUpdate != null) _eventReaderUpdate.cancel();

    print('setEnabledSystemUIOverlays out');
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    bookShelfNotify.setReadBook(this.bookId, this.readerHelper.getCurChapter(), this.readerHelper.curPage>1?this.readerHelper.curPage-1:0);

    super.dispose();
  }

  void setUp() async {
    //这个方法把状态栏和虚拟按键隐藏掉
    print('setEnabledSystemUIOverlays in');
    await SystemChrome.setEnabledSystemUIOverlays([]);

    resetContent(this.curChapter, PageJumpType.stay);

  }

  //重新设置阅读内容
  void resetContent(int chapterId, PageJumpType jumpType) async {

    Future.delayed(Duration(milliseconds: 100), () {
      readerHelper.start(chapterId, lastPage:this.widget.lastPage);
    });
  }

  //点击事件处理
  onTap(Offset position) async {

    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
//      SystemChrome.setEnabledSystemUIOverlays(
//          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      setState(() {
        isMenuVisible = true;
      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  previousPage() {
    if(readerHelper.prePage()) {
      pageController.previousPage();
    }
  }

  nextPage() {
    if(readerHelper.nextPage()) {
      pageController.nextPage();
    }
  }

  onPageChanged(int index) {
    print('onPageChanged $index');

  }

  Widget buildPage(BuildContext context, int index) {
    PageInfo pageInfo = readerHelper.getPageInfo(index);
    print('buildPage  $index');
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);
      },
      child: ReaderView(pageInfo, index, readerHelper),
    );
  }

  GlobalKey canvasKey = GlobalKey();
  buildPageView() {

    return EffectView(
      pageController,
      itemBuilder: buildPage,
    );

//    return GestureDetector(
//      onTapUp: (TapUpDetails details) {
//        onTap(details.globalPosition);
//      },
//      child: Container(
//        width: double.infinity,
//        height: double.infinity,
//        child: RepaintBoundary(
//          child: PageGesture(canvasKey, readerHelper,
//            itemBuilder: buildPage,
//            pageController: pageController,
//          ),
//        ),
//      ),
//    );

//    return Container(
//      width: double.infinity,
//      height: double.infinity,
//      child: RepaintBoundary(
//        child: PageGesture(canvasKey, readerHelper,
//          itemBuilder: buildPage,
//          pageController: pageController,
//          onTapUp: (Offset position){
//            onTap(position);
//          },
//        ),
//    ));
  }

  buildMenu() {
    if (!isMenuVisible) {
      return Container();
    }

    return ReaderMenu((int type) {
        switch(type) {
          case 1://选择章节
            setState(() {
              isMenuVisible=false;
              isMenuChapterVisible=true;
            });
            break;
          case 2://夜间模式
            SettingManager.instance.switchNightMode();
            setState(() {
            });
            break;
          case 3://设置
            setState(() {
              isMenuVisible=false;
              isFontSettingVisible=true;
            });
            break;
          case 4://关闭menu，开始阅读

            break;
          case 5: //分享
            setState(() {
              this.isShareVisible = true;
            });
            break;
          case 6://隐藏菜单
//            SystemChrome.setEnabledSystemUIOverlays([]);
            setState(() {
              this.isMenuVisible = false;
            });
            break;
          case 7://back键
            AppNavigator.pop(context);
            break;
        }
      }
    );
  }


  Widget buildFontSetting() {
    if(!isFontSettingVisible) {
      return Container();
    }

    return ReadFontSetting(() {
      setState(() {
        isFontSettingVisible = !isFontSettingVisible;
      });
    }, () {
      setState(() {
      });
    }, () {
      readerHelper.start(readerHelper.getCurChapter());

    });
  }

  Widget buildMenuChapter() {
    if(!isMenuChapterVisible) {
      return Container();
    }

    return ReaderMenuChapter((int type, int value) {
      if(type == 1) {
        setState(() {
          isMenuChapterVisible = !isMenuChapterVisible;
        });
      } else if(type == 2) {
        isMenuChapterVisible = !isMenuChapterVisible;
        if(value != readerHelper.getCurPage()) {
          readerHelper.start(value);
        }
      }
    }, this.bookId, this.curChapter);
  }

  @override
  Widget build(BuildContext context) {
//    print('readerHelper.totalPage():${readerHelper.totalPage()}');
//    // TODO: implement build
//    if (readerHelper.totalPage() ==0 ) {
//      return Scaffold(
//        body: AnnotatedRegion(
//        value: SystemUiOverlayStyle.dark,
//        child: WillPopScope(
//          onWillPop: _onWillPop,
//          child: Container(
//            color: Color(SettingManager.instance.getFontBackGround()),
//          ),
//        ),
//      ),);
//    }

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: SCColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: SCColor.darkGray,decoration: TextDecoration.none), ),
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
            buildPageView(),
            buildMenu(),
            buildFontSetting(),
            buildMenuChapter(),
          ],
        ),
      ),
    );


  }
}
