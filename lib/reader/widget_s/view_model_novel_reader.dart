import 'package:flutter/material.dart';
import '../reader_helper.dart';
import 'helper_reader_content.dart';
import 'manager_reader_progress.dart';
import 'model_reader_content.dart';
import 'package:flutter/rendering.dart';
import '../widget/effect_page_controller.dart';

typedef void OnRequestContent<T>(int novelId, int volumeId, int chapterId);
typedef void OnContentChanged(ReaderOperateEnum currentContentOperate);

class NovelReaderViewModel extends ChangeNotifier {
  ReaderHelper readerHelper;

  NovelReaderContentModel _contentModel;

  ReaderProgressManager progressManager;

  OnContentChanged contentChangedCallback;

  Paint bgPaint = Paint();

  TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

  bool isDisposed=false;

  factory NovelReaderViewModel(
      ReaderHelper readerHelper) =>
      NovelReaderViewModel._(readerHelper);

  NovelReaderViewModel._(ReaderHelper readerHelper) {
    this.readerHelper = readerHelper;

    _contentModel = NovelReaderContentModel(this);
    progressManager = ReaderProgressManager(this);
  }

  void registerContentOperateCallback(OnContentChanged contentChangedCallback) {
    this.contentChangedCallback = contentChangedCallback;
  }

  void updateChapterIndex(int chapterIndex) {}

  bool isCanGoNext() {
    return progressManager.isHasNextPage();
  }

  bool isCanGoPre() {
    return progressManager.isHasPrePage();
  }

  bool isHasPrePage() {
    return progressManager.isHasPrePage();
  }


  void nextPage() async {
    progressManager.nextPage();
  }

  void prePage() async {
    progressManager.prePage();
  }

  Future<bool> goToTargetPage(int index) async {
    if (contentChangedCallback != null) {
      contentChangedCallback(ReaderOperateEnum.OPERATE_JUMP_PAGE);
    }
    return progressManager.goToTargetPage(index);
  }

  ReaderProgressStateEnum getCurrentState() {
    return progressManager.getCurrentProgressState();
  }

  ReaderContentCanvasDataValue getPrePage() {
    return prePageData;
  }

  ReaderContentCanvasDataValue getCurrentPage() {
    return curPageData;
  }

  ReaderContentCanvasDataValue getNextPage() {
    return nextPageData;
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed=true;
    _contentModel.clear();
    progressManager = null;
    readerHelper = null;
    _contentModel = null;
  }

  void notifyRefresh() {
    if(hasListeners){
      notifyListeners();
    }
  }

  GlobalKey nextPageKey;
  GlobalKey curPageKey;
  GlobalKey prePageKey;

  void setNextPageKey(GlobalKey prePageKey, GlobalKey curPageKey, GlobalKey nextPageKey) {
    this.prePageKey=prePageKey;
    this.curPageKey=curPageKey;
    this.nextPageKey=nextPageKey;
  }

  ReaderContentCanvasDataValue nextPageData=ReaderContentCanvasDataValue();
  ReaderContentCanvasDataValue curPageData=ReaderContentCanvasDataValue();
  ReaderContentCanvasDataValue prePageData=ReaderContentCanvasDataValue();
  Future<void> cachePage() async {
    RenderRepaintBoundary boundary = curPageKey.currentContext.findRenderObject();
    curPageData.pageImage?.dispose();
    curPageData.pageImage = await boundary.toImage();
    boundary = prePageKey.currentContext.findRenderObject();
    prePageData.pageImage?.dispose();
    prePageData.pageImage = await boundary.toImage();

    boundary = nextPageKey.currentContext.findRenderObject();
    nextPageData.pageImage?.dispose();
    nextPageData.pageImage = await boundary.toImage();
  }


  EffectPageController pageController;
  setPageController(EffectPageController pageController) {
    this.pageController = pageController;
  }


}
