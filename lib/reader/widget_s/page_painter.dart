import 'package:flutter/material.dart';
import 'package:flutter_local_book/reader/widget_s/manager_reader_page.dart';

class PagePainter extends CustomPainter {

  ReaderPageManager pageManager;
  TouchEvent currentTouchData;

  PagePainter(this.pageManager);

  void setTouchEvent(TouchEvent event) {
    currentTouchData=event;
    pageManager.setCurrentTouchEvent(event);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
//    print('111111');
//    var _bgPaint = Paint()
//        ..isAntiAlias = true
//        ..style = PaintingStyle.fill
//        ..color= Colors.yellow;
//
//    canvas.drawRect(Offset.zero & size, _bgPaint);

    if(pageManager != null) {
      pageManager.setPageSize(size);
      pageManager.onPageDraw(canvas);
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return pageManager.shouldRepaint(oldDelegate, this);
  }

}