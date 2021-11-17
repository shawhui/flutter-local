import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_book/reader/widget_s/animator/controller_animation_with_listener_number.dart';
import 'package:flutter_local_book/reader/widget_s/page_painter.dart';
import '../reader_helper.dart';
import 'manager_reader_page.dart';
import 'view_model_novel_reader.dart';
import '../widget/effect_page_controller.dart';
import 'package:flutter_local_book/common.dart';
class PageGesture extends StatefulWidget {

  final ReaderHelper readerHelper;
  final IndexedWidgetBuilder itemBuilder;
  final EffectPageController pageController;
  final void Function(Offset position) onTapUp;

  PageGesture(Key key, this.readerHelper, {this.itemBuilder,this.pageController, this.onTapUp}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PageGestureState();
  }
}


class _PageGestureState extends State<PageGesture> with TickerProviderStateMixin{

  GlobalKey canvasKey = GlobalKey();
  ReaderPageManager pageManager;
  TouchEvent currentTouchEvent = TouchEvent(TouchEvent.ACTION_UP, null);
  AnimationController animationController;
  PagePainter mPainter;
  NovelReaderViewModel viewModel;

  GlobalKey curPageKey = GlobalKey();
  GlobalKey prePageKey = GlobalKey();
  GlobalKey nextPageKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadData(BuildContext context, NovelReaderViewModel viewModel) {
    this.viewModel=viewModel;
    switch(ReaderPageManager.TYPE_ANIMATION_COVER_TURN) {
      case ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN:
      case ReaderPageManager.TYPE_ANIMATION_COVER_TURN:
        animationController=AnimationControllerWithListenerNumber(
          vsync: this
        );
        break;
      case ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN:
        animationController=AnimationControllerWithListenerNumber.unbounded(vsync: this);
        break;
    }

    if(animationController != null) {
      pageManager = ReaderPageManager(this.widget.readerHelper);
      pageManager.setCurrentAnimation(ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN);
      pageManager.setCurrentCanvasContainerContext(canvasKey);
      pageManager.setContentViewModel(viewModel);
      pageManager.setAnimationController(animationController);
      pageManager.setOnTapUp(this.widget.onTapUp);
      this.widget.pageController.listen((EffectPageBloc data) {
        switch(data.type) {
          case ActionType.JumpPage:  //跳页
            currentTouchEvent=TouchEvent(TouchEvent.ACTION_UP, Offset.zero);
            if(data.value == 1) {
              pageManager.tapNextPage();
            } else {
              pageManager.tapPrePage();
            }
            break;
          case ActionType.ChangeChapter:
            break;
          default:
            break;
        }
      });

      viewModel.setNextPageKey(prePageKey, curPageKey, nextPageKey);
      viewModel.setPageController(this.widget.pageController);
      mPainter = PagePainter(pageManager);
    }
  }

  void refreshModel() {
    if(!isMove()) {
      Future.delayed(Duration(milliseconds: 50), () async {
        debugPrint('cache page');
        viewModel.cachePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<NovelReaderViewModel>(
      create: (context) {
        NovelReaderViewModel viewModel=NovelReaderViewModel(this.widget.readerHelper);
        loadData(context,viewModel);
        return viewModel;
      },
      child: Consumer<NovelReaderViewModel>(
        builder: (context, counter, child) {
          return buildView(context);
        },
      ),
    );
  }
  Map<int, Widget> cacheMap={};
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

  int count=0;

  bool isMove() {
    if(pageManager.currentState == STATE.STATE_ANIMATING) {
      return true;
    } else {
      if(currentTouchEvent.action != TouchEvent.ACTION_UP) {
        return true;
      }
    }
    return false;
  }

  Widget buildView(context) {
    // TODO: implement build
    print('buildview pageManager.currentState:${isMove()}');
    refreshModel();
    int cur = this.widget.readerHelper.getCurPage();
    int next = cur+1;
    int pre = cur-1;
    print('curpage:$cur');
    Widget curPage = getPageByIndex(cur, false);
    Widget nextPage = getPageByIndex(next, false);
    Widget prePage = getPageByIndex(pre, false);

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory> {
        PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>
        (
          () => PanGestureRecognizer(),
          (PanGestureRecognizer instance) {
            instance..onDown=(detail) {
//              debugPrint('onDown    ${detail.globalPosition.dx}   ${detail.globalPosition.dy}');
              if(currentTouchEvent.action != TouchEvent.ACTION_DOWN ||
              currentTouchEvent.touchPos != detail.localPosition) {
                currentTouchEvent = TouchEvent(TouchEvent.ACTION_DOWN, detail.localPosition);
                mPainter.setTouchEvent(currentTouchEvent);
//                canvasKey.currentContext.findRenderObject().markNeedsPaint();
                setState(() {
                });
              }
            }..onUpdate=(detail) {
//              debugPrint('onUpdate    ${detail.globalPosition.dx}   ${detail.globalPosition.dy}');
              if(currentTouchEvent.action!=TouchEvent.ACTION_MOVE ||
              currentTouchEvent.touchPos!=detail.localPosition) {
                currentTouchEvent=TouchEvent(TouchEvent.ACTION_MOVE, detail.localPosition);
                mPainter.setTouchEvent(currentTouchEvent);

                canvasKey.currentContext.findRenderObject().markNeedsPaint();
                setState(() {
                });
              }
            }..onEnd=(detail) {
//              debugPrint('onEnd   ${detail.velocity.pixelsPerSecond.dx}   ${ detail.velocity.pixelsPerSecond.dy}');
              if(currentTouchEvent.action!=TouchEvent.ACTION_UP ||
                  currentTouchEvent.touchPos!=Offset.zero) {
                currentTouchEvent=TouchEvent(TouchEvent.ACTION_UP, Offset.zero);
                currentTouchEvent.touchDetail = detail;
                mPainter.setTouchEvent(currentTouchEvent);
//                canvasKey.currentContext.findRenderObject().markNeedsPaint();
                setState(() {
                });
              }
            };
          }

        )
      },
      child: Builder(
          builder: (context) {
            if(!isMove()) {
              return Stack(
                children: <Widget>[
                  RepaintBoundary(
                    key: curPageKey,
                    child: curPage,
                  ),
                  Transform.translate(
                    offset: Offset(-Screen.width*2, 0),
                    child: RepaintBoundary(
                      key: prePageKey,
                      child: prePage,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-Screen.width*2, 0),
                    child: RepaintBoundary(
                      key: nextPageKey,
                      child: nextPage,
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
                child: CustomPaint(
                  key: canvasKey,
                  painter: PagePainter(pageManager),
                ),
              );
            }
          }
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController?.dispose();
    super.dispose();
  }
}