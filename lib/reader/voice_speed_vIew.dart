import 'dart:ui';

import 'package:flutter/material.dart';
class VoiceSpeedView extends CustomPainter {

  final int speed;

  VoiceSpeedView(this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint blackPaint = Paint()
        ..color = Colors.black
        ..isAntiAlias=true
        ..strokeWidth=5.0;


    canvas.drawPoints(PointMode.points,
      [
        Offset(20, 20),
      ],
      blackPaint,
    );


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}