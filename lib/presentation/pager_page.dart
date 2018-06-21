import 'package:flutter/material.dart';
import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unsplash_gallery_flutter_app/colors.dart';
import 'package:unsplash_gallery_flutter_app/models/images_provider.dart';

class PagerPage extends StatefulWidget {
  static final tag = 'pager_page';
  Map<String, ImageUnsplash> _favorites;
  int _initialPage;

  PagerPage(this._favorites, this._initialPage);

  @override
  _PagerPageState createState() => _PagerPageState(_favorites, _initialPage);
}

class _PagerPageState extends State<PagerPage> {
  Map<String, ImageUnsplash> _favorites;
  int _initialPage;

  _PagerPageState(this._favorites, this._initialPage);

  Widget _buildPage(ImageUnsplash img) {
    return Hero(
      tag: img.imgId,
      child: CachedNetworkImage(imageUrl: img.thumbImgUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    return Container(
      color: colorDarkBlue,
      child: StreamBuilder(
        stream: imagesBloc.allImages,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return PageView.builder(
              controller: PageController(initialPage: _initialPage),
              itemBuilder: (BuildContext context, int index) =>
                  _buildPage(snapshot.data[index]));
        },
      ),
    );
  }
}
