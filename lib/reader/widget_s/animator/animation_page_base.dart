import 'package:flutter/material.dart';
import '../view_model_novel_reader.dart';
import '../manager_reader_page.dart';
import 'package:flutter_local_book/common.dart';
abstract class BaseAnimationPage{

  Offset mTouch=Offset(0,0);

  AnimationController mAnimationController;

  Size currentSize=Size(Screen.width,Screen.height);

  NovelReaderViewModel readerViewModel;

  void setSize(Size size){
    currentSize=size;
  }

  void setContentViewModel(NovelReaderViewModel viewModel){
    readerViewModel=viewModel;
  }

  void onDraw(Canvas canvas);
  void onTouchEvent(TouchEvent event);
  void setAnimationController(AnimationController controller){
    mAnimationController=controller;
  }

  bool isShouldAnimatingInterrupt(){
   return false;
  }

  bool isCanGoNext(){
    return readerViewModel.isCanGoNext();
  }

  bool isCanGoPre(){
    return readerViewModel.isCanGoPre();
  }

  bool isCancelArea();
  bool isConfirmArea();

  Animation<Offset> getCancelAnimation(AnimationController controller,GlobalKey canvasKey);
  Animation<Offset> getConfirmAnimation(AnimationController controller,GlobalKey canvasKey);
  Simulation getFlingAnimationSimulation(AnimationController controller,DragEndDetails details);

}

enum ANIMATION_TYPE { TYPE_CONFIRM, TYPE_CANCEL,TYPE_FILING }
