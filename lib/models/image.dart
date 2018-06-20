class ImageUnsplash {
  final String _imgId;
  final String _authorName;
  final String _thumbImgUrl;
  final String _fullImgUrl;
  bool _isFavorite;


  ImageUnsplash(this._imgId, this._authorName, this._thumbImgUrl,
      this._fullImgUrl, [this._isFavorite = false]);


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

  String get authorName => _authorName;

  String get thumbImgUrl => _thumbImgUrl;

  String get fullImgUrl => _fullImgUrl;

  bool get isFavorite => _isFavorite;

  set isFavorite(bool value) {
    _isFavorite = value;
  }

  @override
  String toString() {
    return 'ImageUnsplash{_imgId: $_imgId, \n_authorName: $_authorName, '
        '\n_thumbImgUrl: $_thumbImgUrl, \n_fullImgUrl: $_fullImgUrl}';
  }
}
