class ImageUnsplash {
  final String _imgId;
  final String _authorName;
  final String _thumbImgUrl;
  final String _fullImgUrl;
  final String _authorAvatar;
  bool _isFavorite;

  ImageUnsplash(this._imgId, this._authorName, this._thumbImgUrl,
      this._fullImgUrl, this._authorAvatar, [this._isFavorite = false]);

  String get authorName => _authorName;

  String get thumbImgUrl => _thumbImgUrl;

  String get fullImgUrl => _fullImgUrl;

  String get authorAvatar => _authorAvatar;

  bool get isFavorite => _isFavorite;

  String get imgId => _imgId;

  set isFavorite(bool value) {
    _isFavorite = value;
  }

  @override
  String toString() {
    return 'ImageUnsplash{_imgId: $_imgId, \n_authorName: $_authorName, '
        '\n_thumbImgUrl: $_thumbImgUrl, \n_fullImgUrl: $_fullImgUrl}';
  }

  factory ImageUnsplash.fromJson(Map<String, dynamic> response) {
    Map<String, dynamic> urls = response['urls'];
    Map<String, dynamic> user = response['user'];
    return ImageUnsplash(
      response['id'],
      user['name'],
      urls['small'],
      urls['regular'],
      user['profile_image']['medium'],
    );
  }
}
