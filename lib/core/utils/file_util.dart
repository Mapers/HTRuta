import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<io.File> getImageFromNetwork(String url) async {
    io.File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

  Future<io.File> saveImage(String url, ui.Size size) async {

    final file = await getImageFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image, width: 120, height: 120);

    // Save the thumbnail as a PNG.
    return io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
      ..writeAsBytesSync(encodePng(thumbnail));
  }

  Future<ui.Image> getImageFromPath(String imagePath, ui.Size size) async {

    io.File imageFile = await saveImage(imagePath, size);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }
}