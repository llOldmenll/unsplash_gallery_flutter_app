import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUnsplash {
  final String _imgId;
  final String _authorName;
  final String _thumbImgUrl;
  final String _fullImgUrl;

  ImageUnsplash(
      this._imgId, this._authorName, this._thumbImgUrl, this._fullImgUrl);

  String get fullImgUrl => _fullImgUrl;

  String get thumbImgUrl => _thumbImgUrl;

  String get authorName => _authorName;

  String get imgId => _imgId;

  factory ImageUnsplash.fromJson(Map<String, dynamic> response) {
    Map<String, dynamic> urls = response['urls'];
    return ImageUnsplash(
      response['id'],
      response['user']['name'],
      urls['small'],
      urls['regular'],
    );
  }

  @override
  String toString() {
    return 'ImageUnsplash{_imgId: $_imgId, \n_authorName: $_authorName, '
        '\n_thumbImgUrl: $_thumbImgUrl, \n_fullImgUrl: $_fullImgUrl}';
  }
}
