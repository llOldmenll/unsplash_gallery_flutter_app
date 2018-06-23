import 'dart:io';
import 'dart:async';
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

  Future<String> downloadImage(String fileName, String url) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');

    if (file.existsSync()) {
      return '$dir ----- Image $fileName already exist';
    } else {
      var request = await http.get(url);
      await file.writeAsBytes(request.bodyBytes);
      print(file.path);
      return 'Image $fileName was downloaded!';
    }
  }
}
