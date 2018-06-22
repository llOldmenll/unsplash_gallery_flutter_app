import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'image.dart';

class ImagesBloc {
  final List<ImageUnsplash> _images = List();

  int getLength() => _images.length;

  final _additionController = StreamController<List<ImageUnsplash>>();
  Sink<List<ImageUnsplash>> get addition => _additionController.sink;

//  final _favoriteController = StreamController<MapEntry<int, bool>>();
//  Sink<MapEntry<int, bool>> get favorite => _favoriteController.sink;

  final _allImagesSubject = BehaviorSubject<List<ImageUnsplash>>(seedValue: []);
  Stream<List<ImageUnsplash>> get allImages => _allImagesSubject.stream;

  ImagesBloc() {

    _additionController.stream.listen((List<ImageUnsplash> newImages){
      _images.addAll(newImages);
      _allImagesSubject.add(_images);
      print('_additionController.stream.listen ====images-list-length==== ${_images.length}');
    });

//    _favoriteController.stream.listen((MapEntry<int, bool> entry){
//      _images[entry.key].isFavorite = entry.value;
//      _allImagesSubject.add(_images);
//      print('_favoriteController.stream.listen ====images-list-length==== ${_images.length}');
//    });
  }

  void dispose() {
    _additionController.close();
    _allImagesSubject.close();
//    _favoriteController.close();
  }
}
