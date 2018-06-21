import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'image.dart';

class ImagesBloc {
  final List<ImageUnsplash> _images = List();

  int getLength() => _images.length;

  final _additionController = StreamController<List<ImageUnsplash>>();
  Sink<List<ImageUnsplash>> get addition => _additionController.sink;

  final _allImagesSubject = BehaviorSubject<List<ImageUnsplash>>(seedValue: []);
  Stream<List<ImageUnsplash>> get allImages => _allImagesSubject.stream;

  ImagesBloc() {
    _additionController.stream.listen((List<ImageUnsplash> newImages){
      _images.addAll(newImages);
      _allImagesSubject.add(_images);
      print('=================================== ${_images.length}');
    });
  }

  void dispose() {
    _additionController.close();
    _allImagesSubject.close();
  }
}
