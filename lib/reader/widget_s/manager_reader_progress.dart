import 'helper_reader_content.dart';
import 'view_model_novel_reader.dart';

class ReaderProgressManager {
  NovelReaderViewModel readerViewModel;

  ReaderProgressManager(this.readerViewModel);

  ReaderProgressStateEnum currentState = ReaderProgressStateEnum.STATE_NORMAL;

  ReaderProgressStateEnum getCurrentProgressState() {
    if (readerViewModel?.getCurrentPage() == null) {
      currentState = ReaderProgressStateEnum.STATE_LOADING;
    } else if (!readerViewModel.isCanGoNext()) {
      currentState = ReaderProgressStateEnum.STATE_NO_NEXT;
    } else if (!readerViewModel.isCanGoPre()) {
      currentState = ReaderProgressStateEnum.STATE_NO_PRE;
    } else {
      currentState = ReaderProgressStateEnum.STATE_NORMAL;
    }
    return currentState;
  }

  Future<bool> nextPage() async {
    if (currentState == ReaderProgressStateEnum.STATE_NO_NEXT) {
      return false;
    }

    if (readerViewModel.readerHelper.nextPage()) {
      goToNextPage();
    } else {
    }

    return true;
  }

  Future<bool> prePage() async {
    if (currentState == ReaderProgressStateEnum.STATE_NO_PRE) {
      return false;
    }


    if (isHasPrePage()) {
      goToPrePage();
    }

    return true;
  }

  Future<bool> goToTargetPage(int index) async {
//    if (index >= 0 &&
//        index <= currentDataValue.chapterContentConfigs.length - 1 &&
//        index != currentDataValue.currentPageIndex) {
//      if (index == currentDataValue.currentPageIndex + 1) {
//        goToNextPage();
//      } else if (index == currentDataValue.currentPageIndex - 1) {
//        goToPrePage();
//      } else {
//        currentDataValue.currentPageIndex = index;
//      }
//      return true;
//    }
    return false;
  }

  void goToNextPage() async {
    readerViewModel.pageController.nextPageNotify();

    if (!isHasNextPage()) {
      /// 如果当前章没有下一张
      currentState = ReaderProgressStateEnum.STATE_NO_NEXT;
    } else {
      if (readerViewModel.getNextPage() == null) {
        currentState = ReaderProgressStateEnum.STATE_LOADING;
      } else {
        currentState = ReaderProgressStateEnum.STATE_NORMAL;
      }
    }
  }

  void goToPrePage() async {
    readerViewModel.pageController.previousPageNotify();

    if (!isHasPrePage()) {
      /// 如果当前章没有上一张
      currentState = ReaderProgressStateEnum.STATE_NO_PRE;
    } else {
      if (readerViewModel.getPrePage() == null) {
        currentState = ReaderProgressStateEnum.STATE_LOADING;
      } else {
        currentState = ReaderProgressStateEnum.STATE_NORMAL;
      }
    }

  }

  bool isHasPrePage() {
    return readerViewModel.readerHelper.prePage(tip:false);
  }

  bool isHasNextPage() {
    return readerViewModel.readerHelper.nextPage(tip:false);
  }

}

enum ReaderProgressStateEnum {
  STATE_NORMAL,
  STATE_LOADING,
  STATE_NO_PRE,
  STATE_NO_NEXT
}

enum ReaderOperateEnum {
  OPERATE_NEXT_PAGE,
  OPERATE_PRE_PAGE,
  OPERATE_PRE_CHAPTER,
  OPERATE_NEXT_CHAPTER,
  OPERATE_JUMP_PAGE,
  OPERATE_JUMP_CHAPTER,
}
