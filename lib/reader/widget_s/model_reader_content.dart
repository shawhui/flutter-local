import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'helper_reader_content.dart';
import 'view_model_novel_reader.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;


class NovelReaderContentModel {
  NovelReaderViewModel viewModel;

  NovelReaderContentModel(this.viewModel);

  ReaderContentDataValue dataValue;
  ReaderContentDataValue preDataValue;
  ReaderContentDataValue nextDataValue;

  bool isStartLooper = false;

  ui.Picture drawContent(ReaderContentDataValue dataValue, int index) {
    ui.PictureRecorder pageRecorder = new ui.PictureRecorder();
    Canvas pageCanvas = new Canvas(pageRecorder);

    if (dataValue?.chapterContentConfigs?.length == null ||
        dataValue.chapterContentConfigs.length == 0) {
      ///todo: 默认错误页面；
      return pageRecorder.endRecording();
    }
//
//    var pageContengantConfig = dataValue.chapterContentConfigs[index];
//
//    ReaderConfigEntity configEntity = viewModel.getConfigData();
//
//    pageCanvas.drawRect(
//        Offset.zero &
//            Size(ScreenUtils.getScreenWidth(), ScreenUtils.getScreenHeight()),
//        viewModel.bgPaint);
//
//    viewModel.textPainter.text = TextSpan(
//        text: "${dataValue.title}",
//        style: TextStyle(
//            color: Colors.grey[700],
//            height: configEntity.titleHeight.toDouble() /
//                configEntity.titleFontSize,
//            fontWeight: FontWeight.bold,
//            fontSize: configEntity.titleFontSize.toDouble()));
//    viewModel.textPainter.layout(
//        maxWidth: configEntity.pageSize.dx - (2 * configEntity.contentPadding));
//    viewModel.textPainter.paint(
//        pageCanvas,
//        Offset(configEntity.contentPadding.toDouble(),
//            configEntity.contentPadding.toDouble()));
//
//    Offset offset = Offset(
//        configEntity.contentPadding.toDouble(),
//        configEntity.contentPadding.toDouble() +
//            configEntity.titleHeight.toDouble());
//
//    List<String> paragraphContents = pageContentConfig.paragraphContents;
//    for (String content in paragraphContents) {
//      viewModel.textPainter.text = TextSpan(
//          text: content,
//          style: TextStyle(
//              color: Colors.black,
//              height: pageContentConfig.currentContentLineHeight /
//                  pageContentConfig.currentContentFontSize,
//              fontSize: pageContentConfig.currentContentFontSize.toDouble()));
//      viewModel.textPainter.layout(
//          maxWidth:
//              configEntity.pageSize.dx - (2 * configEntity.contentPadding));
//      viewModel.textPainter.paint(pageCanvas, offset);
//
//      offset = Offset(
//          configEntity.contentPadding.toDouble(),
//          offset.dy +
//              viewModel.textPainter.computeLineMetrics().length *
//                  pageContentConfig.currentContentLineHeight);
//
//      offset = Offset(configEntity.contentPadding.toDouble(),
//          offset.dy + pageContentConfig.currentContentParagraphSpacing);
//    }
//
//    viewModel.textPainter.text = TextSpan(
//        text: "${index + 1}/${dataValue.chapterContentConfigs.length}",
//        style: TextStyle(
//            color: Colors.black,
//            height: configEntity.bottomTipHeight.toDouble() /
//                configEntity.bottomTipFontSize,
//            fontSize: configEntity.bottomTipFontSize.toDouble()));
//    viewModel.textPainter.layout(
//        maxWidth: configEntity.pageSize.dx - (2 * configEntity.contentPadding));
//    viewModel.textPainter.paint(
//        pageCanvas,
//        Offset(
//            configEntity.contentPadding.toDouble(),
//            configEntity.pageSize.dy -
//                configEntity.contentPadding.toDouble() -
//                configEntity.bottomTipHeight.toDouble()));

    return pageRecorder.endRecording();
  }

  void clear() {
    viewModel = null;
    isStartLooper = false;
    dataValue = null;
    preDataValue = null;
    nextDataValue = null;

  }
}
