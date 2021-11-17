import 'page_drag.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_book/common.dart';
class EffectCal  {

  Direction direction = Direction.none;
  UpdateType curType=UpdateType.none;

  double dxStart=0;
  double dxUpdate=0;

  double left=0;
  double leftInit=0;
  double width = Screen.width;
  double moveOffset=0;
  double moveInit=0;

  AnimationController controller;
  Animation<double> animation;
  CurvedAnimation curve;

  init(StreamController<SlideUpdate> slideUpdateStream, TickerProvider vSync,) {

    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: vSync);
    curve  = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          slideUpdateStream.add(
              new SlideUpdate(
                UpdateType.doneAnimating,
                this.direction,
                0,
              )
          );
          this.curType = UpdateType.none;
          this.direction = Direction.none;
        }
      })..addListener(() {
        slideUpdateStream.add(
            new SlideUpdate(
              UpdateType.animating,
              Direction,
              0,
            )
        );
      });
  }

  bool dragStart(DragStartDetails details) {
    this.dxStart=details.globalPosition.dx;
    this.dxUpdate=0;
    return false;
  }


  bool dragUpdate(DragUpdateDetails details) {
    this.dxUpdate=details.globalPosition.dx;
    if(this.direction == Direction.none) {
      if (dxUpdate - dxStart > 0 ) {
        this.direction = Direction.leftToRight;
        this.leftInit = -width;
      } else {
        this.direction = Direction.rightToLeft;
        this.leftInit = 0;
      }
      curType = UpdateType.dragging;
    }
    print('dragUpdate   curType:$curType ');
    this.left = this.dxUpdate - this.dxStart;
    return true;
  }

  bool dragEnd(DragEndDetails details) {
    if(this.direction == Direction.leftToRight) {
      if(dxUpdate - dxStart > 0) {
        //触发动画 完成
        curType = UpdateType.animating;
        double moveEnd = 0;
        moveInit = this.leftInit+this.left;
        moveOffset = moveEnd-this.leftInit-this.left;
//        print('moveOffset:$moveOffset   moveInit:$moveInit    dxUpdate:$dxUpdate    Screen.width:${ Screen.width}');
        controller?.forward(from: 0);
      } else {
        //无动画置无状态
        this.direction=Direction.none;
        this.curType=UpdateType.none;
      }
    } else {
      if(dxUpdate - dxStart < 0) {
        curType = UpdateType.animating;
        double moveEnd = -width;
        moveInit = this.leftInit+this.left;
        moveOffset = moveEnd-this.leftInit-this.left;
//        print('moveOffset:$moveOffset   moveInit:$moveInit    dxUpdate:$dxUpdate    Screen.width:${ Screen.width}');
        controller.forward(from: 0);
      } else {
        //无动画置无状态
        this.direction=Direction.none;
        this.curType=UpdateType.none;
      }
    }

    this.dxUpdate=0;
    this.dxStart=0;
    return true;
  }

  tapNextPage() {
    if(curType == UpdateType.none) {
      this.direction = Direction.rightToLeft;
      this.leftInit = 0;
      this.left = 0;
      curType = UpdateType.animating;
      double moveEnd = -width;
      moveInit = this.leftInit + this.left;
      moveOffset = moveEnd - this.leftInit - this.left;
      controller?.forward(from: 0.0);
    }
  }

  tapPrePage() {
    if(curType == UpdateType.none) {
      this.direction = Direction.leftToRight;
      this.leftInit = -width;
      curType = UpdateType.animating;
      double moveEnd = 0;
      moveInit = this.leftInit + this.left;
      moveOffset = moveEnd - this.leftInit - this.left;
      controller?.forward(from: 0.0);
    }
  }

  dispose() {
    controller?.dispose();
  }

  double getTransFormOffsetX() {
    double offsetX=this.leftInit;
    if(curType == UpdateType.animating) {
//      print('getTransFormOffsetX curve.value:${curve.value}  this.moveInit:${this.moveInit}   this.moveOffset:${this.moveOffset}');
      offsetX= this.moveInit+this.moveOffset*(curve.value);
    } else if(curType == UpdateType.dragging) {
      offsetX =this.leftInit + this.left;
    }
//    print('getTransFormOffsetX offsetX:$offsetX');
    return offsetX;
  }


  bool isShowTop() {
    return curType == UpdateType.none;
  }
}