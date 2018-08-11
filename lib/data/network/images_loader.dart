import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:unsplash_gallery_flutter_app/models/image.dart';

class ImagesLoader {
  //Singleton realization
  static final ImagesLoader _instance = ImagesLoader.internal();
  ImagesLoader.internal();
  factory ImagesLoader() => _instance;

//  saveImage(ImageUnsplash img) {
//    _downloadImage().then((bytes) {
//      setState(() {
//        dataBytes = bytes;
//      });
//    });
//  }

  Future<Uint8List> downloadImage(String url) async {
      var request = await http.get(url);
      return request.bodyBytes;
  }
}
