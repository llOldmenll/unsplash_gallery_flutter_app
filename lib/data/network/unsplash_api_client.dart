import 'dart:async';
import 'package:unsplash_gallery_flutter_app/utils/restful_api_utils.dart';
import 'package:unsplash_gallery_flutter_app/models/image.dart';

class UnsplashApiClient {
  final _BASE_URL = 'https://api.unsplash.com/';
  final _BASE_HEADERS = {
    'Accept-Version': 'v1',
    'Authorization':
        'Client-ID 176a609651fb9ae514b26ceade8b6e2df8f82479213a4fb1332d4d383e9640ff'
  };
  RestfulApiUtils _utils = RestfulApiUtils();

  Future<List<ImageUnsplash>> getAllImages(int page) async {
    print('--getAllImages, page = $page');
    final url = _BASE_URL + 'photos?page=$page&per_page=20';
    List<ImageUnsplash> images = List();

    final responseJson = await _utils.get(url, _BASE_HEADERS) as Iterable;
    for (var obj in responseJson) images.add(ImageUnsplash.fromJson(obj));
    return images;
  }
}
