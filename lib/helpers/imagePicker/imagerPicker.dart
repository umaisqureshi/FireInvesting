import 'dart:async';
import 'dart:io';

import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Future<dynamic> getImage() async {
  Completer completer = Completer();
  try {
    MultiImagePicker.pickImages(maxImages: 1).then((value) async {
      final filePath =
      await FlutterAbsolutePath.getAbsolutePath(value.first.identifier);
      File file = File(filePath);
      completer.complete(file);
    });
  } catch (e) {
    completer.completeError(e);
  }
  return completer.future;
}
