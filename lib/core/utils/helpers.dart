import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:math' as math;

Future<Uint8List> assetToBytes( String path,{int width = 100}) async {
  final byteData = await rootBundle.load(path);
  final bytes = byteData.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: width
  );
  final frame = await codec.getNextFrame();
  final newByteData = await frame.image.toByteData(
    format: ui.ImageByteFormat.png
  );

  
  return newByteData.buffer.asUint8List();
}
int generateRandomCode(){
  final rnd = math.Random();
  var next = rnd.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return next.toInt();
}