import 'dart:async';
import 'package:flutter/material.dart';
import '../widget/effect_cal.dart';

class PageDrag extends StatefulWidget {

  final StreamController<SlideUpdate> slideUpdateStream;
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;
  final EffectCal effectCal;
  PageDrag({
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
    this.effectCal
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PageDragState();
  }
}

class PageDragState extends State<PageDrag> {

  Offset dragStart;
  Direction direction=Direction.none;
  EffectCal getCal(){
    return this.widget.effectCal;
  }

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    this.widget.effectCal.dragStart(details);
    direction=Direction.none;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;

      if(direction == Direction.none) {
        if (dx > 0.0) {
          if(widget.canDragRightToLeft) {
            direction = Direction.rightToLeft;
          } else {
            direction = Direction.rightToLeftDeny;
          }
        } else if (dx < 0.0) {
          if(widget.canDragLeftToRight) {
            direction = Direction.leftToRight;
          } else {
            direction = Direction.leftToRightDeny;
          }
        }
      }
      print('onDragUpdate direction:$direction');
      if (direction == Direction.rightToLeft ||
          direction == Direction.leftToRight) {

        if(getCal().dragUpdate(details)) {
          widget.slideUpdateStream.add(
              new SlideUpdate(
                  UpdateType.dragging,
                  direction,
                  dx
              )
          );
        }
      }
    }
  }

  onDragEnd(DragEndDetails details) {
    if(direction != Direction.leftToRightDeny && direction != Direction.rightToLeftDeny) {
      if (getCal().dragEnd(details)) {
        widget.slideUpdateStream.add(
            new SlideUpdate(
              UpdateType.doneDragging,
              Direction.none,
              0.0,
            )
        );
      }
    } else {
      widget.slideUpdateStream.add(
          new SlideUpdate(
            UpdateType.doneDragging,
            direction,
            0.0,
          )
      );
      getCal().direction = Direction.none;
    }

    dragStart=null;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}



enum Direction {
  leftToRight,
  leftToRightDeny,
  rightToLeft,
  rightToLeftDeny,
  none,
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
  none,
}

class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(
    this.updateType,
    this.direction,
    this.slidePercent,
    );
}