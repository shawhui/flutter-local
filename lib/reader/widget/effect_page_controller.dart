import 'dart:async';
import 'package:flutter/material.dart';
import '../page_info.dart';
import '../reader_helper.dart';
class EffectPageController {

  StreamController<EffectPageBloc> _dataController = StreamController<EffectPageBloc>();
  StreamSink<EffectPageBloc> get _dataSink => _dataController.sink;
  Stream<EffectPageBloc> get _dataStream => _dataController.stream;
  StreamSubscription _dataSubscription;

  final ValueChanged<int> onPageChanged;
  final ReaderHelper readerHelper;

  EffectPageController(this.onPageChanged, this.readerHelper);


  int getCurPage() {
    return readerHelper.curPage;
  }

  int nextPageNotify() {
    int page = readerHelper.curPage+1;
    readerHelper.changePage(page);
    onPageChanged(page);
    return page;
  }

  int previousPageNotify() {
    int page = readerHelper.curPage-1;
    readerHelper.changePage(page);
    onPageChanged(page);
    return page;
  }


  void listen(void onData(EffectPageBloc event)) {
    _dataSubscription=_dataStream.listen(onData);
  }

  void previousPage() {
    _dataSink.add(EffectPageBloc(ActionType.JumpPage, value: 0));
  }

  void nextPage() {
    _dataSink.add(EffectPageBloc(ActionType.JumpPage, value: 1));
  }

  void changeChapter() {
    _dataSink.add(EffectPageBloc(ActionType.ChangeChapter));
  }

  void close() {
    _dataSubscription?.cancel();
    _dataController?.close();
  }

  bool isCanLeftToRight(int page) {
    PageInfo pageInfo = readerHelper.getPageInfo(page);
    if(pageInfo != null && pageInfo.actionType == PageActionType.FIRST) {
      return false;
    }
    return true;
  }

  bool isCanRightToLeft(int page) {
    PageInfo pageInfo = readerHelper.getPageInfo(page);
    if(pageInfo != null && pageInfo.actionType == PageActionType.END) {
      return false;
    }
    return true;
  }
}

enum ActionType {
  JumpPage,
  ChangeChapter,

}

class EffectPageBloc{
  ActionType type;
  int value;
  EffectPageBloc(this.type, {this.value});
}